import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/model/kgame_score.dart';
import 'package:app_core/ui/hero/widget/khero_game_end.dart';
import 'package:app_core/ui/hero/widget/khero_game_highscore_dialog.dart';
import 'package:app_core/ui/hero/widget/khero_game_pause_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:app_core/ui/hero/widget/khero_game_count_down_intro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class KHeroJumpMultiRowGame extends StatefulWidget {
  final KHero? hero;

  const KHeroJumpMultiRowGame({this.hero});

  @override
  _KHeroJumpMultiRowGameState createState() => _KHeroJumpMultiRowGameState();
}

class _KHeroJumpMultiRowGameState extends State<KHeroJumpMultiRowGame> {
  static const GAME_NAME = "jump_multi_row";
  static const GAME_ID = "534";

  static const List<String> BACKGROUND_IMAGES = [
    KAssets.IMG_BG_COUNTRYSIDE_LIGHT,
    KAssets.IMG_BG_COUNTRYSIDE_DARK,
    KAssets.IMG_BG_SPACE_LIGHT,
    KAssets.IMG_BG_SPACE_DARK,
    KAssets.IMG_BG_XMAS_LIGHT,
    KAssets.IMG_BG_XMAS_DARK,
  ];
  late final String gameBackground = (BACKGROUND_IMAGES..shuffle()).first;

  int? overlayID;

  int totalLevel = 4;
  int currentLevel = 0;
  bool isShowEndLevel = false;

  KGameScore? score;
  bool isCached = false;

  @override
  void initState() {
    super.initState();

    cacheHeroImages();
  }

  void cacheHeroImages() async {
    setState(() {
      this.isCached = false;
    });
    try {
      for (int i = 0; i < KImageAnimationHelper.animationImages.length; i++) {
        await Future.wait(KImageAnimationHelper.animationImages
            .map((image) => DefaultCacheManager().getSingleFile(image)));
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      this.isCached = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
  }

  void showHeroGameEndOverlay(Function() onFinish) async {
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
    final heroGameLevel = KHeroGameLevel(onFinish: onFinish);
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
            game: GAME_ID,
            score: this.score,
            ascendingSort: false,
            currentLevel: currentLevel,
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
        Align(
          alignment: Alignment.topCenter,
          child: view,
        ),
      ],
    );
    this.overlayID = KOverlayHelper.addOverlay(overlay);
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  BACKGROUND_IMAGES[currentLevel],
                  package: 'app_core',
                ),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
            child: !isCached
                ? Container()
                : SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: KJumpMultiRowGameScreen(
                            hero: widget.hero,
                            isShowEndLevel: isShowEndLevel,
                            totalLevel: totalLevel,
                            onFinishLevel: (level, score, isHaveWrongAnswer) {
                              this.setState(() {
                                this.score = KGameScore()
                                  ..game = GAME_ID
                                  ..avatarURL = KSessionData.me!.avatarURL
                                  ..kunm = KSessionData.me!.kunm
                                  ..level = "$level"
                                  ..score = "$score";
                              });
                              if (level < totalLevel) {
                                print(isHaveWrongAnswer);

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
                              () {
                                this.currentLevel = level;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );

    return Scaffold(
      // appBar: AppBar(title: Text("Play game")),
      body: body,
    );
  }
}

class KJumpMultiRowGameScreen extends StatefulWidget {
  final KHero? hero;
  final Function(int)? onChangeLevel;
  final Function(int, int, bool)? onFinishLevel;
  final bool isShowEndLevel;
  final int? totalLevel;
  final int? level;
  final int? grade;

  const KJumpMultiRowGameScreen({
    this.hero,
    this.onChangeLevel,
    this.onFinishLevel,
    required this.isShowEndLevel,
    this.totalLevel,
    this.level,
    this.grade,
  });

  @override
  KJumpMultiRowGameScreenState createState() => KJumpMultiRowGameScreenState();
}

class KJumpMultiRowGameScreenState extends State<KJumpMultiRowGameScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AudioPlayer backgroundAudioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  String? correctAudioFileUri;
  String? wrongAudioFileUri;
  String? backgroundAudioFileUri;

  late Animation<Offset> _bouncingAnimation;
  late Animation<double> _playerScaleAnimation,
      _scaleAnimation,
      _moveUpAnimation,
      _heroScaleAnimation;
  late AnimationController _heroScaleAnimationController,
      _playerScaleAnimationController,
      _bouncingAnimationController,
      _scaleAnimationController,
      _moveUpAnimationController,
      _spinAnimationController,
      _playerSpinAnimationController;

  double screenWidth = 0;
  double screenHeight = 0;
  double heroY = 0;
  double initialPos = 0;
  double height = 0;
  double time = 0;
  double gravity = -8.0;
  double velocity = 2.0;
  Timer? _timer;
  bool isStart = false;
  bool isShowCountDown = false;
  double heroHeight = 90;
  double heroWidth = 90;
  int trueAnswer = 2;
  bool? result;
  bool isScroll = true;
  double scrollSpeed = 0.01;
  bool isShooting = false;
  int eggReceive = 0;
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

  List<List<String>> levelQuestions = [];
  List<List<int>> levelRightAnswers = [];

  List<String> get questions => levelQuestions[currentLevel];

  List<int> get rightAnswers => levelRightAnswers[currentLevel];
  int currentQuestionIndex = 0;
  int? spinningHeroIndex;
  int? currentShowStarIndex;
  int? currentCollisionIndex;
  bool isPlaySound = false;

  static const List<double> BARRIER_Y_BASE = [-0.3, 0.35, 1];
  List<double> barrierX = [2, 3.5, 5];
  List<double> barrierY = [1, -0.3, 0.35];
  List<String> barrierImageUrls = [
    KImageAnimationHelper.randomImage,
    KImageAnimationHelper.randomImage,
    KImageAnimationHelper.randomImage,
  ];

  double get randomBarrierY =>
      BARRIER_Y_BASE[Math.Random().nextInt(BARRIER_Y_BASE.length)];

  double get randomBarrierX => Math.Random().nextDouble() * 3.5 + 2;

  int get getRandomAnswer => rightAnswers[currentQuestionIndex] <= 4
      ? (Math.Random().nextInt(4) + rightAnswers[currentQuestionIndex])
      : (Math.Random().nextInt(4) + rightAnswers[currentQuestionIndex] - 3);

  bool get canRestartGame =>
      currentLevel + 1 < levelHardness.length ||
      (currentLevel < levelHardness.length &&
          (rightAnswerCount / questions.length) < levelHardness[currentLevel]);

  List<int> barrierValues = [];
  double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.6, 0.4],
    [0.6, 0.4],
  ];

  double topBoundary = -2.1;

  int? overlayID;
  bool isPause = false;
  bool isBackgroundSoundPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

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
      this.getRandomAnswer,
    ];

    _playerScaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          this._playerSpinAnimationController.forward();
        } else if (mounted && status == AnimationStatus.dismissed) {}
      });
    _playerScaleAnimation = new Tween(
      begin: 1.0,
      end: 1.2,
    ).animate(new CurvedAnimation(
        parent: _playerScaleAnimationController, curve: Curves.bounceOut));

    _playerSpinAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (mounted && status == AnimationStatus.completed) {
              this._playerSpinAnimationController.reset();
              this._playerScaleAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {}
          });

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
            }
            Future.delayed(Duration(milliseconds: 500), () {
              if (mounted) {
                this._scaleAnimationController.reset();
                this._moveUpAnimationController.reset();
              }
            });
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
        height = (gravity * 0.5) * time * time + velocity * time;
        double pos = initialPos - height;

        setState(() {
          if (pos <= topBoundary) {
            time += 0.08;
          } else if (pos <= 0) {
            heroY = pos;
          } else {
            heroY = 0;
          }
        });

        // if (isReachTarget() &&
        //     (lastGetPointTime == null ||
        //         lastGetPointTime!.difference(DateTime.now()).inMilliseconds <
        //             -1000)) {
        //   this._scaleAnimationController.reset();
        //   this.setState(() {
        //     isShowPlusPoint = true;
        //   });
        //   this._scaleAnimationController.forward();
        //   setState(() {
        //     // resetPos = true;
        //     lastGetPointTime = DateTime.now();
        //     points = points + 1;
        //   });
        // }
        if (isScroll) {
          checkResult();
        }

        this.setState(() {
          time += 0.01;
        });

        moveMap();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && !this.isPause) showPauseDialog();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _timer?.cancel();
    _heroScaleAnimationController.dispose();
    _playerScaleAnimationController.dispose();
    _bouncingAnimationController.dispose();
    _scaleAnimationController.dispose();
    _moveUpAnimationController.dispose();
    _spinAnimationController.dispose();
    _playerSpinAnimationController.dispose();

    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }

    audioPlayer.dispose();
    backgroundAudioPlayer.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  bool isReachTarget() {
    return false;
  }

  void jump() {
    setState(() {
      if (isStart) {
        time = 0;
        initialPos = heroY;
      }
    });
  }

  void showPauseDialog() {
    if (this.isPause) return;
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
            barrierX[i] = this.randomBarrierX;
            if (i > 0 && barrierX[i - 1] >= 1.5) {
              barrierX[i] = barrierX[i] + 1.5;
            } else if (i == 0 && barrierX[barrierX.length - 1] >= 1.5) {
              barrierX[i] = barrierX[i] + 1.5;
            }
            barrierY[i] = this.randomBarrierY;
            // points += 1;
            barrierValues[i] = this.getRandomAnswer;
          });
        }
      }
    }
  }

  void loadAudioAsset() async {
    try {
      await backgroundAudioPlayer.setReleaseMode(ReleaseMode.LOOP);

      Directory tempDir = await getTemporaryDirectory();

      ByteData correctAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/correct.mp3");
      ByteData wrongAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/wrong.mp3");
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

      this.setState(() {
        this.correctAudioFileUri = correctAudioTempFile.uri.toString();
        this.wrongAudioFileUri = wrongAudioTempFile.uri.toString();
        this.backgroundAudioFileUri = backgroundAudioTempFile.uri.toString();
      });
    } catch (e) {}
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

  void checkResult() {
    if (isScroll) {
      for (int i = 0; i < barrierX.length; i++) {
        double _barrierWidth =
            (MediaQuery.of(context).size.width / 2) * barrierWidth / 2 - 10;
        double _barrierHeight = (MediaQuery.of(context).size.height / 2) *
            barrierHeight[i][1] *
            0.3;

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
            ((-0.8 + barrierY[i]) * MediaQuery.of(context).size.height / 2) / 2;
        double topBarrier =
            ((-0.8 + barrierY[i]) * MediaQuery.of(context).size.height / 2) /
                    2 -
                _barrierHeight;

        double bottomBulletY =
            (heroY * MediaQuery.of(context).size.height / 2) / 2 +
                (heroHeight / 2);
        double topBulletY =
            (heroY * MediaQuery.of(context).size.height / 2) / 2 -
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
          bool isTrueAnswer =
              barrierValues[i] == rightAnswers[currentQuestionIndex];

          if (this.currentCollisionIndex == null ||
              this.currentCollisionIndex != i) {
            if (!isPlaySound) {
              this.setState(() {
                this.isPlaySound = true;
              });
              playSound(isTrueAnswer);
            }
          }

          this.setState(() {
            this.currentCollisionIndex = i;
          });

          if (isTrueAnswer) {
            this.setState(() {
              spinningHeroIndex = i;
              isShooting = false;
            });
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
                  this.barrierX = [
                    this.randomBarrierX,
                    this.randomBarrierX,
                    this.randomBarrierX
                  ];
                  this.barrierY = [
                    this.randomBarrierY,
                    this.randomBarrierY,
                    this.randomBarrierY
                  ];
                  barrierImageUrls = [
                    KImageAnimationHelper.randomImage,
                    KImageAnimationHelper.randomImage,
                    KImageAnimationHelper.randomImage,
                  ];
                  barrierValues = [
                    this.getRandomAnswer,
                    this.getRandomAnswer,
                    this.getRandomAnswer,
                  ];
                  this.currentCollisionIndex = null;
                  this.isPlaySound = false;
                });
                Future.delayed(Duration(milliseconds: 50), () {
                  this.setState(() {
                    isScroll = true;
                  });
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
                  this.barrierX = [
                    this.randomBarrierX,
                    this.randomBarrierX,
                    this.randomBarrierX
                  ];
                  this.barrierY = [
                    this.randomBarrierY,
                    this.randomBarrierY,
                    this.randomBarrierY
                  ];
                  barrierImageUrls = [
                    KImageAnimationHelper.randomImage,
                    KImageAnimationHelper.randomImage,
                    KImageAnimationHelper.randomImage,
                  ];
                  barrierValues = [
                    this.getRandomAnswer,
                    this.getRandomAnswer,
                    this.getRandomAnswer,
                  ];
                  this.currentCollisionIndex = null;
                  this.isPlaySound = false;
                });
              }
            });
          } else {
            _playerScaleAnimationController.forward();
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
      this.currentCollisionIndex = null;
      this.isPlaySound = false;
      this.isStart = true;
      this.isScroll = true;
      this.isShooting = false;
      this.result = null;
      this.points = 0;
      this.currentQuestionIndex = 0;
      this.spinningHeroIndex = null;
      this.barrierX = [
        this.randomBarrierX,
        this.randomBarrierX,
        this.randomBarrierX
      ];
      this.barrierY = [
        this.randomBarrierY,
        this.randomBarrierY,
        this.randomBarrierY
      ];
      this.barrierImageUrls = [
        KImageAnimationHelper.randomImage,
        KImageAnimationHelper.randomImage,
        KImageAnimationHelper.randomImage,
      ];
      this.barrierValues = [
        this.getRandomAnswer,
        this.getRandomAnswer,
        this.getRandomAnswer,
      ];
      isWrongAnswer = false;
      rightAnswerCount = 0;
      wrongAnswerCount = 0;
      canAdvance = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      fit: StackFit.expand,
      children: [
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
        Container(
          width: heroWidth,
          height: heroHeight,
          alignment: Alignment(0, heroY + 1),
          child: Transform.rotate(
            angle: -this._playerSpinAnimationController.value * 4 * Math.pi,
            child: ScaleTransition(
              scale: _playerScaleAnimation,
              child: widget.hero?.imageURL != null
                  ? Image(
                      image: CachedNetworkImageProvider(widget.hero!.imageURL!),
                      width: heroWidth,
                      height: heroHeight,
                      errorBuilder: (context, error, stack) => Image.asset(
                        KAssets.IMG_TAMAGO_CHAN,
                        width: heroWidth,
                        height: heroHeight,
                        package: 'app_core',
                      ),
                    )
                  : Image.asset(
                      KAssets.IMG_TAMAGO_CHAN,
                      width: heroWidth,
                      height: heroHeight,
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
        // if (isStart && result != null)
        //   Align(
        //     alignment: Alignment(0, -0.6),
        //     child: Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 10),
        //       child: Text(
        //         result! ? "Right answer!" : "Wrong answer",
        //         style: TextStyle(
        //           fontSize: 30,
        //           color: result! ? Colors.green : Colors.red,
        //         ),
        //       ),
        //     ),
        //   ),
        // if (isStart || result != null)
        //   Align(
        //     alignment: Alignment.topRight,
        //     child: Container(
        //       width: 80,
        //       height: 80,
        //       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage(Assets.IMG_TARGET_ORANGE),
        //           fit: BoxFit.contain,
        //         ),
        //       ),
        //       child: Text(
        //         "${this.rightAnswerCount}",
        //         textScaleFactor: 1.0,
        //         textAlign: TextAlign.center,
        //         style: Theme.of(context).textTheme.bodyText1!.copyWith(
        //               color: Colors.white,
        //               fontSize: 35,
        //               fontWeight: FontWeight.bold,
        //             ),
        //       ),
        //     ),
        //   ),
        // if (isStart || result != null)
        //   Align(
        //     alignment: Alignment.bottomRight,
        //     child: Container(
        //       width: 80,
        //       height: 80,
        //       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage(Assets.TARGET_ORANGE),
        //           fit: BoxFit.contain,
        //         ),
        //       ),
        //       child: Text(
        //         "${this.points}",
        //         textAlign: TextAlign.center,
        //         style: Theme.of(context).textTheme.bodyText1!.copyWith(
        //               fontSize: 35,
        //               fontWeight: FontWeight.bold,
        //             ),
        //       ),
        //     ),
        //   ),
        if (isStart) ...[
          Align(
            alignment: Alignment(0, -0.8),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Container(
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
                  questions[currentQuestionIndex],
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Stack(
                children: [
                  ...List.generate(
                    barrierValues.length,
                    (i) => _Barrier(
                      barrierX: barrierX[i],
                      barrierY: barrierY[i],
                      barrierWidth: barrierWidth,
                      barrierHeight: barrierHeight[i][1],
                      imageUrl: barrierImageUrls[i],
                      value: barrierValues[i],
                      rotateAngle: spinningHeroIndex == i
                          ? -this._spinAnimationController.value * 4 * Math.pi
                          : 0,
                      bouncingAnimation: spinningHeroIndex == i
                          ? _bouncingAnimation.value
                          : Offset(0, 0),
                      scaleAnimation:
                          spinningHeroIndex == i ? _heroScaleAnimation : null,
                      starY: _moveUpAnimation.value,
                      isShowStar: currentShowStarIndex == i,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        GestureDetector(
            onTap: (isShowCountDown || widget.isShowEndLevel || isPause)
                ? () {}
                : (isStart
                    ? jump
                    : (result == null
                        ? start
                        : (canRestartGame ? restartGame : () {})))),
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
  final double barrierY;
  final String imageUrl;
  final double rotateAngle;
  final Animation<double>? scaleAnimation;
  final int value;
  final Offset bouncingAnimation;
  final double? starY;
  final bool? isShowStar;

  _Barrier({
    required this.barrierHeight,
    required this.barrierWidth,
    required this.barrierX,
    required this.barrierY,
    required this.imageUrl,
    required this.rotateAngle,
    this.scaleAnimation,
    required this.value,
    required this.bouncingAnimation,
    this.starY,
    this.isShowStar,
  });

  @override
  Widget build(context) {
    return Container(
      alignment: Alignment(
          (2 * barrierX + barrierWidth) / (2 - barrierWidth), barrierY),
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
                      "${this.value}",
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
                            child: Image(
                              image: CachedNetworkImageProvider(imageUrl),
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
                        : (Image(
                            image: CachedNetworkImageProvider(imageUrl),
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
