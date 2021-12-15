import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/model/kanswer.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/model/kquestion.dart';
import 'package:app_core/model/kscore.dart';
import 'package:app_core/ui/hero/widget/khero_game_count_down_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_end.dart';
import 'package:app_core/ui/hero/widget/khero_game_highscore_dialog.dart';
import 'package:app_core/ui/hero/widget/khero_game_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_pause_dialog.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class KHeroShootingGame extends StatefulWidget {
  final KHero? hero;

  const KHeroShootingGame({this.hero});

  @override
  _KHeroShootingGameState createState() => _KHeroShootingGameState();
}

class _KHeroShootingGameState extends State<KHeroShootingGame> {
  static const GAME_NAME = "shooting_game";

  static const List<String> BG_IMAGES = [
    KAssets.IMG_BG_COUNTRYSIDE_LIGHT,
    KAssets.IMG_BG_COUNTRYSIDE_DARK,
    KAssets.IMG_BG_SPACE_LIGHT,
    KAssets.IMG_BG_SPACE_DARK,
    KAssets.IMG_BG_XMAS_LIGHT,
    KAssets.IMG_BG_XMAS_DARK,
  ];

  int? overlayID;

  int totalLevel = 2;
  int currentLevel = 0;
  bool isShowIntro = true;
  bool isShowEndLevel = false;

  String? scoreID;
  List<KScore> scores = [];
  List<KQuestion> questions = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadScore();
    loadGame();
  }

  loadGame() {
    this.setState(() {
      questions = KServerHandler.questionsMockup();
      isLoaded = true;
    });
  }

  loadScore() async {
    KPrefHelper.get(GAME_NAME).then((value) {
      if (value != null) {
        setState(() {
          scores = KScore.decode(value);
        });
      }
    });
  }

  saveScore() async {
    KPrefHelper.put(GAME_NAME, KScore.encode(scores));
  }

  @override
  void dispose() {
    saveScore();
    super.dispose();
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
  }

  String get gameBackground => BG_IMAGES[this.currentLevel % BG_IMAGES.length];

  void showHeroGameEndOverlay(Function() onFinish) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameEnd = KHeroGameEnd(
      hero: KHero()..imageURL = KImageAnimationHelper.randomImage,
      onFinish: onFinish,
    );
    showCustomOverlay(heroGameEnd);
  }

  void showHeroGameLevelOverlay(Function() onFinish) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameLevel = KHeroGameLevel(
      onFinish: onFinish,
    );
    showCustomOverlay(heroGameLevel);
  }

  void showHeroGameHighscoreOverlay(Function() onClose) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameHighScore = Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: KGameHighscoreDialog(
            onClose: onClose,
            game: GAME_NAME,
            scores: this.scores,
            ascendingSort: false,
            scoreID: this.scoreID,
            currentLevel: currentLevel + 1,
          ),
        ),
      ],
    );
    showCustomOverlay(heroGameHighScore);
  }

  void showCustomOverlay(Widget view) {
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        // Container(color: Colors.black.withOpacity(0.6)),
        Align(alignment: Alignment.topCenter, child: view),
      ],
    );
    this.overlayID = KOverlayHelper.addOverlay(overlay);
  }

  @override
  Widget build(BuildContext context) {
    final body = !isLoaded
        ? Container()
        : Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage(this.gameBackground, package: 'app_core'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BackButton(),
                        Expanded(
                          child: this.isShowIntro
                              ? GestureDetector(
                                  onTap: () => this
                                      .setState(() => this.isShowIntro = false),
                                  child: Container(
                                    child: KGameIntro(
                                      hero: widget.hero,
                                      onFinish: () => this.setState(
                                          () => this.isShowIntro = false),
                                    ),
                                  ),
                                )
                              : KShootingGameScreen(
                                  hero: widget.hero,
                                  totalLevel: totalLevel,
                                  isShowEndLevel: isShowEndLevel,
                                  questions: questions,
                                  onFinishLevel:
                                      (level, score, isHaveWrongAnswer) {
                                    final scoreID = Uuid().v4();
                                    this.setState(() {
                                      this.scoreID = scoreID;
                                      this.scores.add(
                                            KScore()
                                              ..game = GAME_NAME
                                              ..user = KSessionData.me
                                              ..level = level
                                              ..scoreID = scoreID
                                              ..score = score.toDouble(),
                                          );
                                    });
                                    if (level < totalLevel) {
                                      // if (!isHaveWrongAnswer) {
                                      //   this.setState(() {
                                      //     this.levelHighscores.add(score);
                                      //   });
                                      // }
                                      this.showHeroGameLevelOverlay(
                                        () {
                                          if (this.overlayID != null) {
                                            KOverlayHelper.removeOverlay(
                                                this.overlayID!);
                                            this.overlayID = null;
                                          }
                                          this.showHeroGameHighscoreOverlay(() {
                                            this.setState(() {
                                              this.isShowEndLevel = false;
                                            });
                                            if (this.overlayID != null) {
                                              KOverlayHelper.removeOverlay(
                                                  this.overlayID!);
                                              this.overlayID = null;
                                            }
                                          });
                                        },
                                      );
                                    } else {
                                      this.showHeroGameHighscoreOverlay(() {
                                        this.setState(() {
                                          this.isShowEndLevel = false;
                                        });
                                        if (this.overlayID != null) {
                                          KOverlayHelper.removeOverlay(
                                              this.overlayID!);
                                          this.overlayID = null;
                                        }
                                      });
                                    }
                                  },
                                  onChangeLevel: (level) => this.setState(
                                      () => this.currentLevel = level),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );

    return Scaffold(body: body);
  }
}

class KShootingGameScreen extends StatefulWidget {
  final KHero? hero;
  final Function(int)? onChangeLevel;
  final Function(int, int, bool)? onFinishLevel;
  final bool isShowEndLevel;
  final List<KQuestion> questions;
  final int? totalLevel;
  final int? level;
  final int? grade;

  const KShootingGameScreen({
    this.hero,
    this.onChangeLevel,
    this.onFinishLevel,
    required this.questions,
    required this.isShowEndLevel,
    this.totalLevel,
    this.level,
    this.grade,
  });

  @override
  KShootingGameScreenState createState() => KShootingGameScreenState();
}

class KShootingGameScreenState extends State<KShootingGameScreen>
    with TickerProviderStateMixin {
  AudioPlayer backgroundAudioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  String? correctAudioFileUri;
  String? wrongAudioFileUri;
  String? shootingAudioFileUri;
  String? backgroundAudioFileUri;

  late Animation<Offset> _bouncingAnimation;
  late Animation<double> _barrelScaleAnimation,
      _scaleAnimation,
      _moveUpAnimation,
      _heroScaleAnimation;
  late AnimationController _barrelScaleAnimationController,
      _heroScaleAnimationController,
      _bouncingAnimationController,
      _scaleAnimationController,
      _moveUpAnimationController,
      _spinAnimationController;

  double screenWidth = 0;
  double screenHeight = 0;
  double heroY = 1;
  double initialPos = 1;
  double height = 0;
  double time = 0;
  double gravity = 0.0;
  double velocity = 3.5;
  Timer? _timer;
  bool isStart = false;
  double heroHeight = 90;
  double heroWidth = 90;
  bool isShowCountDown = false;
  int trueAnswer = 2;
  double bulletSpeed = 0.01;
  bool? result;
  bool isScroll = true;
  double scrollSpeed = 0.01;
  bool isShooting = false;
  int eggReceive = 0;
  double bulletHeight = 40;
  double bulletWidth = 40;
  List<double> bulletsY = [];
  List<double> bulletsTime = [];
  bool isWrongAnswer = false;
  int rightAnswerCount = 0;
  int wrongAnswerCount = 0;
  int totalLevel = 1;
  int currentLevel = 0;
  bool canAdvance = false;
  double baseLevelHardness = 0.7;
  List<double> levelHardness = [];
  List<int> levelPoints = [];
  List<String> baseLevelIconAssets = [
    KAssets.BULLET_BALL_GREEN,
    KAssets.BULLET_BALL_BLUE,
    KAssets.BULLET_BALL_ORANGE,
    KAssets.BULLET_BALL_RED,
  ];
  List<String> levelIconAssets = [];

  int points = 0;
  bool resetPos = false;
  bool isShowPlusPoint = false;
  DateTime? lastGetPointTime;
  bool isPlaySound = false;

  List<List<String>> levelQuestions = [];
  List<List<int>> levelRightAnswers = [];
  int currentQuestionIndex = 0;

  List<KQuestion> get questions => widget.questions;

  KQuestion get currentQuestion => questions[currentQuestionIndex];

  List<KAnswer> get currentQuestionAnswers => currentQuestion.answers ?? [];

  int get currentCorrectAnswer =>
      int.parse(currentQuestion.correctAnswer?.text ?? "0");
  int? spinningHeroIndex;
  int? currentShowStarIndex;

  List<double> barrierX = [2, 2 + 1.5];
  List<String> barrierImageUrls = [
    KImageAnimationHelper.randomImage,
    KImageAnimationHelper.randomImage,
  ];

  KAnswer get getRandomAnswer => currentQuestionAnswers[
      Math.Random().nextInt(currentQuestionAnswers.length)];

  bool get canRestartGame =>
      currentLevel + 1 < totalLevel ||
      (currentLevel < totalLevel &&
          (rightAnswerCount / questions.length) < levelHardness[currentLevel]);

  List<KAnswer> barrierValues = [];
  double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.6, 0.4],
  ];
  int introShakeTime = 2;

  int? overlayID;
  bool isPause = false;
  bool isBackgroundSoundPlaying = false;

  @override
  void initState() {
    super.initState();

    this.currentLevel = widget.level ?? 0;
    this.totalLevel = widget.totalLevel ?? 1;
    this.levelHardness = List.generate(
      this.totalLevel,
      (index) => baseLevelHardness + (index * 0.1),
    );
    this.levelPoints = List.filled(this.totalLevel, 0);
    this.levelIconAssets = List.generate(
      this.totalLevel,
      (index) => baseLevelIconAssets[
          Math.Random().nextInt(baseLevelIconAssets.length)],
    );
    this.levelQuestions = List.filled(
      this.totalLevel,
      [
        "1 + 1",
        "3 + 2",
        "4 - 1",
        "4 + 5",
        "2 x 1",
        "2 x 3",
        "1 + 2 - 1",
        "4 + 8 - 5",
        "1 x 2 + 3",
        "1 + 2 x 3",
      ],
    );
    this.levelRightAnswers = List.filled(
      this.totalLevel,
      [
        2,
        5,
        3,
        9,
        2,
        6,
        2,
        7,
        5,
        7,
      ],
    );

    loadAudioAsset();

    barrierValues = [
      this.getRandomAnswer,
      this.getRandomAnswer,
    ];

    _barrelScaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          this._barrelScaleAnimationController.reverse();
        } else if (mounted && status == AnimationStatus.dismissed) {}
      });
    _barrelScaleAnimation = new Tween(
      begin: 1.0,
      end: 0.9,
    ).animate(new CurvedAnimation(
        parent: _barrelScaleAnimationController, curve: Curves.bounceOut));

    _heroScaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          this._spinAnimationController.forward();
        } else if (mounted && status == AnimationStatus.dismissed) {
          Future.delayed(Duration(milliseconds: 50), () {
            this.setState(() {
              spinningHeroIndex = null;
            });
          });
        }
      });
    _heroScaleAnimation = new Tween(
      begin: 1.0,
      end: 1.2,
    ).animate(new CurvedAnimation(
        parent: _heroScaleAnimationController, curve: Curves.bounceOut));

    _bouncingAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _bouncingAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              // _bouncingAnimationController.forward(from: 0.0);
              this._heroScaleAnimationController.forward();
            }
          });
    _bouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -10.0))
        .animate(_bouncingAnimationController);

    _spinAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (mounted && status == AnimationStatus.completed) {
              this._spinAnimationController.reset();
              this._heroScaleAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {}
          });

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 1000), () {
            if (mounted) {
              this.setState(() {
                currentShowStarIndex = null;
              });
              Future.delayed(Duration(milliseconds: 500), () {
                if (mounted) {
                  this._scaleAnimationController.reset();
                  this._moveUpAnimationController.reset();
                }
              });
            }
          });
        } else if (mounted && status == AnimationStatus.dismissed) {}
      });
    _scaleAnimation = new Tween(
      begin: 1.0,
      end: 2.0,
    ).animate(new CurvedAnimation(
        parent: _scaleAnimationController, curve: Curves.bounceOut));

    _moveUpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        // if (mounted && status == AnimationStatus.completed) {
        //   Future.delayed(Duration(milliseconds: 500), () {
        //     this.setState(() {
        //       isShowPlusPoint = false;
        //     });
        //     Future.delayed(Duration(milliseconds: 500), () {
        //       this._scaleAnimationController.reset();
        //     });
        //   });
        // } else if (mounted && status == AnimationStatus.dismissed) {}
      });
    _moveUpAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _moveUpAnimationController, curve: Curves.bounceOut));

    // this.screenHeight = MediaQuery.of(context).size.height;
    // this.screenWidth = MediaQuery.of(context).size.width;

    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (isStart && !isPause) {
        for (int i = 0; i < bulletsY.length; i++) {
          double bulletY = bulletsY[i];
          double bulletTime = bulletsTime[i];

          height = gravity * bulletTime * bulletTime + velocity * bulletTime;
          final pos = initialPos - height;
          if (pos <= -2) {
            setState(() {
              bulletsY.removeAt(i);
              bulletsTime.removeAt(i);
            });
            return;
          } else if (pos < 1) {
            setState(() {
              bulletsY[i] = pos;
            });
          } else {
            setState(() {
              bulletsY[i] = 1;
            });
          }

          setState(() {
            bulletsTime[i] += bulletSpeed;
          });

          if (isStart && isScroll) {
            checkResult(bulletY, i);
          }
        }

        if (isStart) moveMap();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _barrelScaleAnimationController.dispose();
    _heroScaleAnimationController.dispose();
    _bouncingAnimationController.dispose();
    _scaleAnimationController.dispose();
    _moveUpAnimationController.dispose();
    _spinAnimationController.dispose();

    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }

    audioPlayer.dispose();
    backgroundAudioPlayer.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  void showPauseDialog() {
    if (this.isBackgroundSoundPlaying) {
      toggleBackgroundSound();
    }
    this.setState(() {
      this.isPause = true;
    });
    final view = KGamePauseDialog(
      onExit: () {
        if (this.overlayID != null) {
          KOverlayHelper.removeOverlay(this.overlayID!);
          this.overlayID = null;
        }
        Navigator.of(context).pop();
      },
      onResume: () {
        if (this.overlayID != null) {
          KOverlayHelper.removeOverlay(this.overlayID!);
          this.overlayID = null;
        }
        if (!this.isBackgroundSoundPlaying) {
          toggleBackgroundSound();
        }
        this.setState(() {
          this.isPause = false;
        });
      },
    );
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.center,
          child: view,
        ),
      ],
    );
    this.overlayID = KOverlayHelper.addOverlay(overlay);
  }

  void showCountDownOverlay() {
    this.setState(() {
      this.isShowCountDown = true;
    });
    final view = KGameCountDownIntro(
      onFinish: () {
        this.setState(() {
          this.isShowCountDown = false;
        });

        if (this.overlayID != null) {
          KOverlayHelper.removeOverlay(this.overlayID!);
          this.overlayID = null;
        }

        if (!isStart && currentLevel == 0) {
          if (backgroundAudioPlayer.state != PlayerState.PLAYING) {
            this.setState(() {
              this.isBackgroundSoundPlaying = true;
            });
            backgroundAudioPlayer.play(backgroundAudioFileUri ?? "",
                isLocal: true);
          }
          setState(() {
            isStart = true;
            time = 0;
          });
        }
      },
    );
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.center,
          child: view,
        ),
      ],
    );
    this.overlayID = KOverlayHelper.addOverlay(overlay);
  }

  void loadAudioAsset() async {
    try {
      await backgroundAudioPlayer.setReleaseMode(ReleaseMode.LOOP);

      Directory tempDir = await getTemporaryDirectory();

      ByteData correctAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/correct.mp3");
      ByteData wrongAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/wrong.mp3");
      ByteData shootingAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/gun_fire.mp3");
      ByteData backgroundAudioFileData = await rootBundle
          .load("packages/app_core/assets/audio/background.mp3");

      File correctAudioTempFile = File('${tempDir.path}/correct.mp3');
      await correctAudioTempFile
          .writeAsBytes(correctAudioFileData.buffer.asUint8List(), flush: true);

      File wrongAudioTempFile = File('${tempDir.path}/wrong.mp3');
      await wrongAudioTempFile
          .writeAsBytes(wrongAudioFileData.buffer.asUint8List(), flush: true);

      File backgroundAudioTempFile = File('${tempDir.path}/background.mp3');
      await backgroundAudioTempFile.writeAsBytes(
          backgroundAudioFileData.buffer.asUint8List(),
          flush: true);

      File shootingAudioTempFile = File('${tempDir.path}/gun_fire.mp3');
      await shootingAudioTempFile.writeAsBytes(
          shootingAudioFileData.buffer.asUint8List(),
          flush: true);

      this.setState(() {
        this.correctAudioFileUri = correctAudioTempFile.uri.toString();
        this.wrongAudioFileUri = wrongAudioTempFile.uri.toString();
        this.shootingAudioFileUri = shootingAudioTempFile.uri.toString();
        this.backgroundAudioFileUri = backgroundAudioTempFile.uri.toString();
      });
    } catch (e) {}
  }

  bool isReachTarget() {
    return false;
  }

  void fire() async {
    if (!isShooting && bulletsY.length < 3) {
      try {
        await audioPlayer.play(shootingAudioFileUri ?? "", isLocal: true);
      } catch (e) {}
      if (!_barrelScaleAnimationController.isAnimating) {
        _barrelScaleAnimationController.forward();
      }
      setState(() {
        bulletsY = [
          ...bulletsY,
          1,
        ];
        bulletsTime = [
          ...bulletsTime,
          0,
        ];
        isShooting = true;
      });
      Future.delayed(Duration(milliseconds: 10), () {
        setState(() {
          isShooting = false;
        });
      });
    }
  }

  void toggleBackgroundSound() {
    if (this.isBackgroundSoundPlaying) {
      this.setState(() {
        this.isBackgroundSoundPlaying = false;
      });
      this.backgroundAudioPlayer.pause();
    } else {
      this.setState(() {
        this.isBackgroundSoundPlaying = true;
      });
      this.backgroundAudioPlayer.resume();
    }
  }

  void moveMap() {
    if (isScroll) {
      for (int i = 0; i < barrierX.length; i++) {
        double speed = scrollSpeed;
        if (currentLevel < totalLevel) {
          speed += scrollSpeed * levelHardness[currentLevel];
        }
        setState(() {
          barrierX[i] -= scrollSpeed;
        });

        if (barrierX[i] <= -1.5) {
          setState(() {
            barrierX[i] += 3;
            // points += 1;
            barrierValues[i] = this.getRandomAnswer;
          });
        }
      }
    }
  }

  void playSound(bool isTrueAnswer) async {
    try {
      if (isTrueAnswer) {
        await audioPlayer.play(correctAudioFileUri ?? "", isLocal: true);
      } else {
        await audioPlayer.play(wrongAudioFileUri ?? "", isLocal: true);
      }
    } catch (e) {}
    this.setState(() {
      this.isPlaySound = false;
    });
  }

  void checkResult(double bulletY, int bulletIndex) {
    if (isScroll) {
      for (int i = 0; i < barrierX.length; i++) {
        double _barrierWidth =
            (MediaQuery.of(context).size.width / 2) * barrierWidth / 2;
        double _barrierHeight =
            (MediaQuery.of(context).size.height / 2) * barrierHeight[i][1];

        double leftBarrier =
            (((2 * barrierX[i] + barrierWidth) / (2 - barrierWidth)) *
                        MediaQuery.of(context).size.width) /
                    2 -
                (_barrierWidth / 2);
        double rightBarrier =
            (((2 * barrierX[i] + barrierWidth) / (2 - barrierWidth)) *
                        MediaQuery.of(context).size.width) /
                    2 +
                (_barrierWidth / 2);

        double bottomBarrier =
            (-0.7 * MediaQuery.of(context).size.height / 2) / 2 +
                (_barrierHeight / 2);
        double topBarrier =
            (-0.7 * MediaQuery.of(context).size.height / 2) / 2 -
                (_barrierHeight / 2);

        double bottomBulletY =
            (bulletY * MediaQuery.of(context).size.height / 2) / 2 +
                (heroHeight / 2);
        double topBulletY =
            (bulletY * MediaQuery.of(context).size.height / 2) / 2 -
                (heroHeight / 2);

        if ((leftBarrier < -heroWidth / 2 && rightBarrier >= heroWidth / 2 ||
                leftBarrier <= -heroWidth / 2 &&
                    rightBarrier >= -heroWidth / 2 ||
                leftBarrier <= heroWidth / 2 &&
                    rightBarrier >= heroWidth / 2) &&
            (topBulletY <= bottomBarrier && bottomBulletY >= bottomBarrier ||
                topBulletY >= topBarrier && bottomBulletY <= bottomBarrier ||
                topBulletY <= topBarrier &&
                    bottomBulletY <= bottomBarrier &&
                    bottomBulletY >= topBarrier)) {
          this._bouncingAnimationController.forward();
          this.setState(() {
            bulletsY.removeAt(bulletIndex);
            bulletsTime.removeAt(bulletIndex);
            spinningHeroIndex = i;
            isShooting = false;
          });
          bool isTrueAnswer = barrierValues[i].isCorrect ?? false;

          if (!isPlaySound) {
            this.setState(() {
              isPlaySound = true;
            });
            playSound(isTrueAnswer);
          }

          if (isTrueAnswer) {
            this._scaleAnimationController.reset();
            this._scaleAnimationController.forward();
            this.setState(() {
              result = true;
              levelPoints[currentLevel] = levelPoints[currentLevel] + 5;
              isScroll = false;
              if (!isWrongAnswer) {
                currentShowStarIndex = i;
                rightAnswerCount += 1;
                this._moveUpAnimationController.reset();
                this._moveUpAnimationController.forward();
              }
              isWrongAnswer = false;
            });

            Future.delayed(Duration(milliseconds: 1500), () {
              if (mounted && currentQuestionIndex + 1 < questions.length) {
                this.setState(() {
                  currentQuestionIndex = currentQuestionIndex + 1;
                  barrierX = [2, 2 + 1.5];
                  barrierImageUrls = [
                    KImageAnimationHelper.randomImage,
                    KImageAnimationHelper.randomImage
                  ];
                  barrierValues = [
                    this.getRandomAnswer,
                    this.getRandomAnswer,
                  ];
                });
                Future.delayed(Duration(milliseconds: 50), () {
                  isScroll = true;
                });
              } else {
                if (widget.onFinishLevel != null) {
                  widget.onFinishLevel!(currentLevel + 1,
                      levelPoints[currentLevel], wrongAnswerCount > 0);
                }
                this.setState(() {
                  if (rightAnswerCount / questions.length >=
                      levelHardness[currentLevel]) {
                    eggReceive = eggReceive + 1;
                    if (currentLevel + 1 < totalLevel) {
                      canAdvance = true;
                    }
                  }
                  isStart = false;
                  barrierX = [2, 2 + 1.5];
                  barrierImageUrls = [
                    KImageAnimationHelper.randomImage,
                    KImageAnimationHelper.randomImage
                  ];
                  barrierValues = [
                    this.getRandomAnswer,
                    this.getRandomAnswer,
                  ];
                });
              }
            });
          } else {
            this.setState(() {
              result = false;
              levelPoints[currentLevel] = levelPoints[currentLevel] > 0
                  ? levelPoints[currentLevel] - 1
                  : 0;
              if (!isWrongAnswer) {
                wrongAnswerCount += 1;
                isWrongAnswer = true;
              }
            });
          }
        }
      }
    }
  }

  void start() {
    if (!isStart) {
      if (currentLevel == 0) {
        showCountDownOverlay();
      } else {
        setState(() {
          isStart = true;
          time = 0;
        });
      }
    }
  }

  void restartGame() {
    if (currentLevel + 1 < totalLevel &&
        (rightAnswerCount / questions.length) >= levelHardness[currentLevel]) {
      this.setState(() {
        if (widget.onChangeLevel != null)
          widget.onChangeLevel!(currentLevel + 1);
        currentLevel += 1;
      });
    }
    this.setState(() {
      this.bulletsY = [];
      this.bulletsTime = [];
      this.isPlaySound = true;
      this.isStart = true;
      this.isScroll = true;
      this.isShooting = false;
      this.result = null;
      this.points = 0;
      this.currentQuestionIndex = 0;
      this.spinningHeroIndex = null;
      this.barrierX = [2, 2 + 1.5];
      this.barrierImageUrls = [
        KImageAnimationHelper.randomImage,
        KImageAnimationHelper.randomImage,
      ];
      isWrongAnswer = false;
      rightAnswerCount = 0;
      wrongAnswerCount = 0;
      canAdvance = false;
      this.barrierValues = [getRandomAnswer, getRandomAnswer];
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      fit: StackFit.expand,
      children: [
        if (isStart)
          Align(
            alignment: Alignment(-1, 1),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        reverse: true,
                        children: List.generate(eggReceive, (index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Image.asset(
                              KAssets.IMG_EGG,
                              width: 32,
                              height: 32,
                              package: 'app_core',
                            ),
                          );
                        }),
                      ),
                    ),
                    Image.asset(
                      KAssets.IMG_NEST,
                      fit: BoxFit.fitWidth,
                      package: 'app_core',
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (!isStart && !isShowCountDown && !widget.isShowEndLevel)
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentLevel == 0 && result == null) ...[
                    Text(
                      "Level ${currentLevel + 1}",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8,
                            offset: Offset(2, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        "START",
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  if (currentLevel >= 0 &&
                      result != null &&
                      canRestartGame) ...[
                    Text(
                      "${((rightAnswerCount / questions.length) * 100).floor()}% Correct",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    canAdvance
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 8,
                                  offset: Offset(2, 6),
                                ),
                              ],
                            ),
                            child: Text(
                              "NEXT LEVEL",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 8,
                                  offset: Offset(2, 6),
                                ),
                              ],
                            ),
                            child: Text(
                              "REPLAY LEVEL",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ],
                  if (!canRestartGame) ...[
                    Text(
                      "Game Over",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ...List.generate(
          bulletsY.length,
          (i) => Align(
            alignment: Alignment(0, bulletsY[i] - 0.1),
            child: Container(
              width: bulletWidth,
              height: bulletWidth,
              child: Image.asset(
                KAssets.IMG_TAMAGO_LIGHT_4,
                width: bulletWidth,
                height: bulletWidth,
                package: 'app_core',
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 10,
                ),
                if (isStart || result != null)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 50,
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 30, right: 10),
                        decoration: BoxDecoration(
                          color: Color(0xff2c1c44),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "${this.rightAnswerCount}",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Color(0xfffdcd3a),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      if (currentLevel < totalLevel &&
                          levelIconAssets[currentLevel].isNotEmpty)
                        Positioned(
                          left: -40,
                          top: -15,
                          child: SizedBox(
                            height: 80,
                            child: Image.asset(
                              levelIconAssets[currentLevel],
                              fit: BoxFit.contain,
                              package: 'app_core',
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, 1),
          child: Container(
            width: heroWidth,
            height: heroHeight,
            child: ScaleTransition(
              scale: _barrelScaleAnimation,
              child: Image.asset(
                KAssets.IMG_CANNON_BARREL,
                width: heroWidth,
                height: heroHeight,
                package: 'app_core',
              ),
            ),
          ),
        ),
        if (isStart)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 50,
              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(2, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      currentQuestion.questionText ?? "",
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Stack(
                    children: [
                      ...List.generate(
                        barrierValues.length,
                        (i) => _Barrier(
                          barrierX: barrierX[i],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[i][1],
                          imageUrl: barrierImageUrls[i],
                          answer: barrierValues[i],
                          rotateAngle: spinningHeroIndex == i
                              ? -this._spinAnimationController.value *
                                  4 *
                                  Math.pi
                              : 0,
                          bouncingAnimation: spinningHeroIndex == i
                              ? _bouncingAnimation.value
                              : Offset(0, 0),
                          scaleAnimation: spinningHeroIndex == i
                              ? _heroScaleAnimation
                              : null,
                          starY: _moveUpAnimation.value,
                          isShowStar: currentShowStarIndex == i,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        GestureDetector(
          onTap: (isShowCountDown || widget.isShowEndLevel || isPause)
              ? () {}
              : (isStart
                  ? fire
                  : (result == null
                      ? start
                      : (canRestartGame ? restartGame : () {}))),
        ),
        if (!isPause)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isStart || result != null)
                    InkWell(
                      child: Container(
                        width: 50,
                        height: 50,
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          this.isBackgroundSoundPlaying
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: Color(0xff2c1c44),
                          size: 30,
                        ),
                      ),
                      onTap: () => this.toggleBackgroundSound(),
                    ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    child: Container(
                      width: 50,
                      height: 50,
                      padding:
                          EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.pause,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    onTap: () => showPauseDialog(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );

    return body;
  }
}

class _Barrier extends StatelessWidget {
  final double barrierWidth;
  final double barrierHeight;
  final double barrierX;
  final String imageUrl;
  final double rotateAngle;
  final Animation<double>? scaleAnimation;
  final KAnswer answer;
  final Offset bouncingAnimation;
  final double? starY;
  final bool? isShowStar;

  _Barrier({
    required this.barrierHeight,
    required this.barrierWidth,
    required this.barrierX,
    required this.imageUrl,
    required this.rotateAngle,
    this.scaleAnimation,
    required this.answer,
    required this.bouncingAnimation,
    this.starY,
    this.isShowStar,
  });

  @override
  Widget build(context) {
    return Container(
      alignment:
          Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth), -0.7),
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) * barrierWidth,
        height: (MediaQuery.of(context).size.height / 2) * barrierHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: Offset(0, 0),
                child: Transform.translate(
                  offset: Offset(0, -40 * (starY ?? 0)),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: (isShowStar ?? false) ? 1 : 0,
                    child: Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width / 2) * barrierWidth,
                  height: (MediaQuery.of(context).size.height / 2) *
                      barrierHeight *
                      0.4,
                  child: FittedBox(
                    child: Text(
                      "${this.answer.text}",
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: bouncingAnimation,
                  child: Transform.rotate(
                    angle: rotateAngle,
                    child: scaleAnimation != null
                        ? (ScaleTransition(
                            scale: scaleAnimation!,
                            child: Image.network(
                              imageUrl,
                              width: (MediaQuery.of(context).size.width / 2) *
                                  barrierWidth,
                              height: (MediaQuery.of(context).size.height / 2) *
                                  barrierHeight *
                                  0.6,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  Image.asset(
                                KAssets.IMG_TAMAGO_LIGHT_1,
                                width: (MediaQuery.of(context).size.width / 2) *
                                    barrierWidth,
                                height:
                                    (MediaQuery.of(context).size.height / 2) *
                                        barrierHeight *
                                        0.6,
                                package: 'app_core',
                              ),
                            ),
                          ))
                        : (Image.network(
                            imageUrl,
                            width: (MediaQuery.of(context).size.width / 2) *
                                barrierWidth,
                            height: (MediaQuery.of(context).size.height / 2) *
                                barrierHeight *
                                0.6,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                                Image.asset(
                              KAssets.IMG_TAMAGO_LIGHT_1,
                              width: (MediaQuery.of(context).size.width / 2) *
                                  barrierWidth,
                              height: (MediaQuery.of(context).size.height / 2) *
                                  barrierHeight *
                                  0.6,
                              package: 'app_core',
                            ),
                          )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
