import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kanswer.dart';
import 'package:app_core/model/kgame.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/model/kquestion.dart';
import 'package:app_core/model/kgame_score.dart';
import 'package:app_core/ui/hero/widget/kegg_hero_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_count_down_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_end.dart';
import 'package:app_core/ui/hero/widget/khero_game_highscore_dialog.dart';
import 'package:app_core/ui/hero/widget/khero_game_pause_dialog.dart';
import 'package:app_core/ui/hero/widget/ktamago_chan_jumping.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class KHeroMovingTapGame extends StatefulWidget {
  final KHero? hero;

  const KHeroMovingTapGame({this.hero});

  @override
  _KHeroMovingTapGameState createState() => _KHeroMovingTapGameState();
}

class _KHeroMovingTapGameState extends State<KHeroMovingTapGame> {
  static const GAME_NAME = "tap_moving";
  static const GAME_ID = "512";

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
  int eggReceive = 0;
  bool isShowEndLevel = false;
  bool isShowIntro = true;

  KGameScore? score;
  KGame? game = null;

  List<KQuestion> get questions => game?.qnas?[0].questions ?? [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    loadGame();
  }

  loadGame() async {
    try {
      setState(() {
        this.isLoaded = false;
      });

      final response = await KServerHandler.getGames(
          gameID: GAME_ID, level: currentLevel.toString());

      if (response.isSuccess &&
          response.games != null &&
          response.games!.length > 0) {
        setState(() {
          this.game = response.games![0];
          this.isLoaded = true;
        });
      } else {
        KSnackBarHelper.error("Can not get game data");
      }
    } catch (e) {}
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
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameEnd = KHeroGameEnd(
      hero: KHero()..imageURL = KImageAnimationHelper.randomImage,
      onFinish: onFinish,
    );
    showCustomOverlay(heroGameEnd);
  }

  void showHeroGameLevelOverlay(Function() onFinish, {bool? canAdvance}) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameLevel =
        KTamagoChanJumping(onFinish: onFinish, canAdvance: canAdvance);
    showCustomOverlay(heroGameLevel);
  }

  void showHeroGameHighscoreOverlay(
      Function() onClose, bool canSaveHighScore) async {
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
            canSaveHighScore: canSaveHighScore,
            currentLevel: currentLevel,
          ),
        ),
      ],
    );
    showCustomOverlay(heroGameHighScore);
  }

  void showCustomOverlay(Widget view) {
    this.setState(() {
      this.isShowEndLevel = true;
    });
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
            child: !isLoaded || game == null
                ? Container()
                : (this.isShowIntro
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          if (this.isShowIntro) ...[
                            KEggHeroIntro(
                                onFinish: () =>
                                    setState(() => this.isShowIntro = false)),
                            GestureDetector(
                                onTap: () =>
                                    setState(() => this.isShowIntro = false)),
                          ],
                        ],
                      )
                    : SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: EdgeInsets.only(
                            //     left: 15,
                            //   ),
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       Navigator.of(context).pop();
                            //     },
                            //     child: Icon(
                            //       Icons.arrow_back_ios,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: KMovingTapGameScreen(
                                gameID: GAME_ID,
                                hero: widget.hero,
                                totalLevel: totalLevel,
                                isShowEndLevel: isShowEndLevel,
                                questions: questions,
                                level: currentLevel,
                                isLoaded: isLoaded,
                                loadGame: loadGame,
                                eggReceive: eggReceive,
                                onEggReceive: () {
                                  this.setState(() {
                                    eggReceive = eggReceive + 1;
                                  });
                                },
                                onFinishLevel: (level, score, canAdvance,
                                    canSaveHighScore) {
                                  if (!canAdvance) {
                                    this.showHeroGameLevelOverlay(() {
                                      this.setState(() {
                                        this.isShowEndLevel = false;
                                      });
                                      if (this.overlayID != null) {
                                        KOverlayHelper.removeOverlay(
                                            this.overlayID!);
                                        this.overlayID = null;
                                      }
                                    }, canAdvance: canAdvance);
                                    return;
                                  }

                                  this.setState(() {
                                    this.score = KGameScore()
                                      ..game = GAME_ID
                                      ..avatarURL = KSessionData.me!.avatarURL
                                      ..kunm = KSessionData.me!.kunm
                                      ..level = "$level"
                                      ..score = "$score";
                                  });

                                  if (level < totalLevel) {
                                    // if (!isHaveWrongAnswer) {
                                    //   this.setState(() {
                                    //     this.levelHighscores.add(score);
                                    //   });
                                    // }
                                    this.showHeroGameLevelOverlay(() {
                                      if (this.overlayID != null) {
                                        KOverlayHelper.removeOverlay(
                                            this.overlayID!);
                                        this.overlayID = null;
                                      }
                                      this.showHeroGameHighscoreOverlay(
                                        () {
                                          this.setState(() {
                                            this.isShowEndLevel = false;
                                          });
                                          if (this.overlayID != null) {
                                            KOverlayHelper.removeOverlay(
                                                this.overlayID!);
                                            this.overlayID = null;
                                          }
                                        },
                                        canSaveHighScore,
                                      );
                                    }, canAdvance: canAdvance);
                                  } else {
                                    this.showHeroGameEndOverlay(
                                      () {
                                        if (this.overlayID != null) {
                                          KOverlayHelper.removeOverlay(
                                              this.overlayID!);
                                          this.overlayID = null;
                                        }
                                        this.showHeroGameHighscoreOverlay(
                                          () {
                                            this.setState(() {
                                              this.isShowEndLevel = false;
                                            });
                                            if (this.overlayID != null) {
                                              KOverlayHelper.removeOverlay(
                                                  this.overlayID!);
                                              this.overlayID = null;
                                            }
                                          },
                                          canSaveHighScore,
                                        );
                                      },
                                    );
                                  }
                                },
                                onChangeLevel: (level) {
                                  this.setState(
                                    () {
                                      this.currentLevel = level;
                                      this.score = null;
                                    },
                                  );
                                  this.loadGame();
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
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

class KMovingTapGameScreen extends StatefulWidget {
  final KHero? hero;
  final String gameID;
  final Function()? onEggReceive;
  final Function()? loadGame;
  final Function(int)? onChangeLevel;
  final Function(int, int, bool, bool)? onFinishLevel;
  final bool isShowEndLevel;
  final bool isLoaded;
  final List<KQuestion> questions;
  final int? totalLevel;
  final int? level;
  final int? eggReceive;
  final int? grade;

  const KMovingTapGameScreen({
    Key? key,
    this.hero,
    this.onEggReceive,
    this.loadGame,
    this.onChangeLevel,
    this.onFinishLevel,
    this.totalLevel,
    required this.gameID,
    required this.isShowEndLevel,
    required this.questions,
    required this.isLoaded,
    this.level,
    this.eggReceive = 0,
    this.grade,
  }) : super(key: key);

  @override
  KMovingTapGameScreenState createState() => KMovingTapGameScreenState();
}

class KMovingTapGameScreenState extends State<KMovingTapGameScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AudioPlayer backgroundAudioPlayer = AudioPlayer();
  AudioPlayer audioPlayer = AudioPlayer();
  String? correctAudioFileUri;
  String? wrongAudioFileUri;
  String? backgroundAudioFileUri;

  late Animation<Offset> _bouncingAnimation;
  late Animation<double> _moveUpAnimation, _heroScaleAnimation;

  late AnimationController _barrierMovingAnimationController,
      _heroScaleAnimationController,
      _bouncingAnimationController,
      _moveUpAnimationController,
      _spinAnimationController;

  double screenWidth = 0;
  double screenHeight = 0;
  double heroY = 0;
  double initialPos = 0;
  double height = 0;
  double time = 0;
  double gravity = -8.0;
  double velocity = 2.0;
  Timer? _timer;
  Timer? _gameTimer;
  bool isStart = false;
  bool isShowCountDown = false;
  double heroHeight = 90;
  double heroWidth = 90;
  int trueAnswer = 2;
  bool? result;
  bool isScroll = true;
  double scrollSpeed = 0.01;
  bool isShooting = false;
  bool isWrongAnswer = false;
  int rightAnswerCount = 0;
  int wrongAnswerCount = 0;
  int totalLevel = 1;
  int currentLevel = 0;
  bool canAdvance = false;
  double baseLevelHardness = 0.7;
  List<double> levelHardness = [];
  List<int> levelPlayTimes = [];
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

  int currentQuestionIndex = 0;

  List<KQuestion> get questions => widget.questions;

  KQuestion get currentQuestion => questions[currentQuestionIndex];

  List<KAnswer> get currentQuestionAnswers => currentQuestion.generateAnswers();

  int? spinningHeroIndex;
  int? currentShowStarIndex;
  bool isPlaySound = false;

  List<double> barrierX = [0, 0, 0, 0];
  List<double> barrierY = [0, 0, 0, 0];
  List<bool> barrierOutSide = [false, false, false, false];

  Math.Random rand = new Math.Random();

  bool get canRestartGame =>
      currentLevel + 1 < totalLevel ||
      (currentLevel < totalLevel &&
          (rightAnswerCount / questions.length) < levelHardness[currentLevel]);

  List<KAnswer> barrierValues = [];
  double topBoundary = -2.1;

  int? overlayID;
  bool isPause = false;
  bool isBackgroundSoundPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    this.currentLevel = widget.level ?? 0;
    this.totalLevel = widget.totalLevel ?? 1;
    this.levelHardness = List.generate(
      this.totalLevel,
      (index) => baseLevelHardness + (index * 0.1),
    );
    this.levelPlayTimes = List.filled(this.totalLevel, 0);
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

    _heroScaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 0),
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

    _moveUpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          // this.setState(() {
          //   isShowPlusPoint = false;
          // });
          // Future.delayed(Duration(milliseconds: 50), () {
          //   this._moveUpAnimationController.reset();
          // });
        }
      });
    _moveUpAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _moveUpAnimationController, curve: Curves.bounceOut));

    // this.screenHeight = MediaQuery.of(context).size.height;
    // this.screenWidth = MediaQuery.of(context).size.width;

    _barrierMovingAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (isStart && mounted && !isPause) {
        if (currentLevel < totalLevel) {
          this.setState(() {
            this.levelPlayTimes[currentLevel] += 16;
          });
        }
      }
    });

    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (isStart && mounted && !isPause) {
        if (barrierOutSide[0] &&
            barrierOutSide[1] &&
            barrierOutSide[2] &&
            barrierOutSide[3]) {
          resetListAnswer();
          Future.delayed(Duration(milliseconds: 50), () {
            randomBoxPosition();
            getListAnswer();
          });
        }
      }
    });

    randomBoxPosition();
    getListAnswer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && !this.isPause)
      showPauseDialog();
    else if (state == AppLifecycleState.resumed && this.isPause) resumeGame();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _gameTimer?.cancel();
    _barrierMovingAnimationController.dispose();
    _heroScaleAnimationController.dispose();
    _bouncingAnimationController.dispose();
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

  void resumeGame() {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    if (isStart && !this.isBackgroundSoundPlaying) {
      toggleBackgroundSound();
    }
    this.setState(() {
      this.isPause = false;
    });
  }

  void showHighscoreDialog() {
    if (this.isPause) return;
    if (this.isBackgroundSoundPlaying) {
      toggleBackgroundSound();
    }
    this.setState(() {
      this.isPause = true;
    });
    final view = Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: KGameHighscoreDialog(
            onClose: resumeGame,
            game: widget.gameID,
            score: null,
            canSaveHighScore: false,
            currentLevel: currentLevel,
          ),
        ),
      ],
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
      onResume: resumeGame,
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

  void resetListAnswer() {
    this.setState(() {
      this.barrierValues = [];
      this.barrierX = [0, 0, 0, 0];
      this.barrierY = [0, 0, 0, 0];
      this.barrierOutSide = [false, false, false, false];
    });
  }

  void getListAnswer() {
    this.setState(() {
      this.barrierValues = currentQuestionAnswers;
    });
  }

  void randomBoxPosition() {
    Math.Random rand = new Math.Random();
    //rand.nextDouble() * (max - min) + min
    double topLeftX = rand.nextDouble() * (-3.0 - -1.5) + -1.5;
    double topLeftY = rand.nextDouble() * (-3.0 - -1.5) + -1.5;
    double topRightX = rand.nextDouble() * (3.0 - 1.5) + 1.5;
    double topRightY = rand.nextDouble() * (-3.0 - -1.5) + -1.5;
    double bottomLeftX = rand.nextDouble() * (-3.0 - -1.5) + -1.5;
    double bottomLeftY = rand.nextDouble() * (3.0 - 1.5) + 1.5;
    double bottomRightX = rand.nextDouble() * (3.0 - 1.5) + 1.5;
    double bottomRightY = rand.nextDouble() * (3.0 - 1.5) + 1.5;
    this.setState(() {
      barrierX[0] = topLeftX;
      barrierY[0] = topLeftY;
      barrierX[1] = topRightX;
      barrierY[1] = topRightY;
      barrierX[2] = bottomLeftX;
      barrierY[2] = bottomLeftY;
      barrierX[3] = bottomRightX;
      barrierY[3] = bottomRightY;
    });
  }

  bool isReachTarget() {
    return false;
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

      if (backgroundAudioPlayer.state != PlayerState.playing) {
        this.setState(() {
          this.isBackgroundSoundPlaying = true;
        });
        backgroundAudioPlayer
            .play(DeviceFileSource(backgroundAudioFileUri ?? ""));
      }
    }
  }

  void loadAudioAsset() async {
    try {
      await backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);
      await backgroundAudioPlayer.setPlayerMode(PlayerMode.mediaPlayer);

      Directory tempDir = await getTemporaryDirectory();

      ByteData correctAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/correct.mp3");
      ByteData wrongAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/wrong.mp3");
      ByteData backgroundAudioFileData = await rootBundle
          .load("packages/app_core/assets/audio/music_background_1.mp3");

      File correctAudioTempFile = File('${tempDir.path}/correct.mp3');
      await correctAudioTempFile
          .writeAsBytes(correctAudioFileData.buffer.asUint8List(), flush: true);

      File wrongAudioTempFile = File('${tempDir.path}/wrong.mp3');
      await wrongAudioTempFile
          .writeAsBytes(wrongAudioFileData.buffer.asUint8List(), flush: true);

      File backgroundAudioTempFile =
          File('${tempDir.path}/music_background_1.mp3');
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
        await audioPlayer.play(DeviceFileSource(correctAudioFileUri ?? ""),
            mode: PlayerMode.lowLatency);
      } else {
        await audioPlayer.play(DeviceFileSource(wrongAudioFileUri ?? ""),
            mode: PlayerMode.lowLatency);
      }
    } catch (e) {}
    this.setState(() {
      this.isPlaySound = false;
    });
  }

  void handlePickAnswer(KAnswer answer, int answerIndex) {
    if (_spinAnimationController.value != 0) {
      return;
    }
    bool isTrueAnswer = answer.isCorrect ?? false;

    if (!isPlaySound) {
      this.setState(() {
        this.isPlaySound = true;
      });
      playSound(isTrueAnswer);
    }

    this.setState(() {
      spinningHeroIndex = answerIndex;
      isShooting = false;
    });
    this._spinAnimationController.reset();
    this._spinAnimationController.forward();

    if (isTrueAnswer) {
      this.setState(() {
        result = true;
        points = points + 5;
        isScroll = false;
        if (!isWrongAnswer) {
          currentShowStarIndex = answerIndex;
          rightAnswerCount += 1;
          if (!_moveUpAnimationController.isAnimating) {
            this._moveUpAnimationController.reset();
            this._moveUpAnimationController.forward();
          }
        }
        isWrongAnswer = false;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          this.setState(() {
            currentShowStarIndex = null;
          });
          Future.delayed(Duration(milliseconds: 500), () {
            if (mounted) {
              this._moveUpAnimationController.reset();

              if (currentQuestionIndex + 1 < questions.length) {
                this.setState(() {
                  currentQuestionIndex = currentQuestionIndex + 1;
                  resetListAnswer();
                  Future.delayed(Duration(milliseconds: 50), () {
                    randomBoxPosition();
                    getListAnswer();
                  });
                });
                Future.delayed(Duration(milliseconds: 50), () {
                  this.setState(() {
                    isScroll = true;
                  });
                });
              } else {
                if (widget.onFinishLevel != null) {
                  widget.onFinishLevel!(
                    currentLevel + 1,
                    levelPlayTimes[currentLevel],
                    rightAnswerCount / questions.length >=
                        levelHardness[currentLevel],
                    rightAnswerCount == questions.length,
                  );
                }
                this.setState(() {
                  if (rightAnswerCount / questions.length >=
                      levelHardness[currentLevel]) {
                    if (widget.onEggReceive != null) widget.onEggReceive!();
                    if (currentLevel + 1 < totalLevel) {
                      canAdvance = true;
                    }
                  }
                  isStart = false;
                  resetListAnswer();
                  Future.delayed(Duration(milliseconds: 50), () {
                    randomBoxPosition();
                    getListAnswer();
                  });
                });
              }
            }
          });
        }
      });
    } else {
      this.setState(() {
        result = false;
        points = points > 0 ? points - 1 : 0;
        if (!isWrongAnswer) {
          wrongAnswerCount += 1;
          isWrongAnswer = true;
        }
      });
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
    } else {
      this.setState(() {
        levelPlayTimes[currentLevel] = 0;
      });
    }

    this.setState(() {
      this.isStart = true;
      this.isScroll = true;
      this.isShooting = false;
      this.result = null;
      this.points = 0;
      this.currentQuestionIndex = 0;
      this.spinningHeroIndex = null;
      resetListAnswer();
      Future.delayed(Duration(milliseconds: 50), () {
        randomBoxPosition();
        getListAnswer();
      });
      isWrongAnswer = false;
      rightAnswerCount = 0;
      wrongAnswerCount = 0;
      canAdvance = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final countDown = KGameCountDownIntro(
      onFinish: () {
        if (mounted) {
          setState(() {
            this.isShowCountDown = false;
            isStart = true;
            time = 0;
          });
        }
      },
    );

    final body = Stack(
      fit: StackFit.expand,
      children: [
        if (isStart || result != null)
          Align(
            alignment: Alignment(-1, -1),
            child: currentLevel < 4
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            KUtil.prettyStopwatchWithFraction(
                              Duration(
                                  milliseconds: levelPlayTimes[currentLevel]),
                            ),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ),
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
                        children:
                            List.generate(widget.eggReceive ?? 0, (index) {
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
                  if (result == null) ...[
                    Text(
                      "Level ${currentLevel + 1}",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () => start(),
                      child: Container(
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
                    if (canAdvance) ...[
                      GestureDetector(
                        onTap: () => restartGame(),
                        child: Container(
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
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      if (widget.loadGame != null)
                        GestureDetector(
                          onTap: () => widget.loadGame!(),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.orange,
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
                        ),
                    ],
                    if (!canAdvance)
                      GestureDetector(
                        onTap: () => restartGame(),
                        child: Container(
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
        // if (!isStart)
        //   GestureDetector(
        //       onTap: (isShowCountDown || widget.isShowEndLevel || isPause)
        //           ? () {}
        //           : (result == null
        //               ? start
        //               : (canRestartGame ? restartGame : () {}))),
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
                          borderRadius: BorderRadius.circular(40),
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
                          left: -30,
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
        if (isStart) ...[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Stack(
                key: Key("${barrierValues.join("_")}"),
                children: barrierValues.length > 0
                    ? [
                        ...List.generate(
                          barrierValues.length,
                          (i) => _Barrier(
                            animationController:
                                _barrierMovingAnimationController,
                            onTap: (KAnswer answer) =>
                                handlePickAnswer(answer, i),
                            onOutSide: () {
                              if (!this.barrierOutSide[i]) {
                                this.setState(() {
                                  this.barrierOutSide[i] = true;
                                });
                              }
                            },
                            barrierX: barrierX[i],
                            barrierY: barrierY[i],
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
                            starY: spinningHeroIndex == i
                                ? _moveUpAnimation.value
                                : 0.0,
                            isShowStar: currentShowStarIndex == i,
                          ),
                        ),
                      ]
                    : [],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
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
                  currentQuestion.text ?? "",
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
        ],
        if (!isPause)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                        Icons.star_border,
                        color: Color(0xff2c1c44),
                        size: 30,
                      ),
                    ),
                    onTap: () => showHighscoreDialog(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  if (isStart || result != null) ...[
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
                  ],
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
        if (isShowCountDown)
          Align(
            alignment: Alignment.center,
            child: countDown,
          ),
      ],
    );

    return body;
  }
}

class _Barrier extends StatefulWidget {
  final AnimationController animationController;
  final double barrierX;
  final double barrierY;
  final double rotateAngle;
  final Animation<double>? scaleAnimation;
  final KAnswer answer;
  final Offset bouncingAnimation;
  final double? starY;
  final bool? isShowStar;
  final Function(KAnswer answer) onTap;
  final Function() onOutSide;

  _Barrier({
    required this.animationController,
    required this.barrierX,
    required this.barrierY,
    required this.rotateAngle,
    this.scaleAnimation,
    required this.answer,
    required this.bouncingAnimation,
    this.starY,
    this.isShowStar,
    required this.onTap,
    required this.onOutSide,
  });

  @override
  _BarrierState createState() => _BarrierState();
}

class _BarrierState extends State<_Barrier>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _movingAnimation;

  late AnimationController _movingAnimationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _movingAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 7000))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.onOutSide();
            } else if (status == AnimationStatus.dismissed) {
              // _bouncingAnimationController.forward(from: 0.0);
            }
          });
    _movingAnimation = Tween(
            begin: Offset(0, 0), end: Offset(widget.barrierX, widget.barrierY))
        .animate(_movingAnimationController);

    _movingAnimationController.forward();
  }

  @override
  void dispose() {
    _movingAnimationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(context) {
    final box = InkWell(
      onTap: () {
        widget.onTap(widget.answer);
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xff2c1c44),
          borderRadius: BorderRadius.circular(5),
        ),
        child: FittedBox(
          child: Text(
            "${widget.answer.text}",
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
    );

    return Container(
      alignment:
          Alignment(_movingAnimation.value.dx, _movingAnimation.value.dy),
      child: Container(
        width: 80,
        height: 80,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: Offset(0, 0),
                child: Transform.translate(
                  offset: Offset(0, -60 * (widget.starY ?? 0)),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: (widget.isShowStar ?? false) &&
                            (widget.answer.isCorrect ?? false)
                        ? 1
                        : 0,
                    child: Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: widget.bouncingAnimation,
              child: Transform.rotate(
                angle: widget.rotateAngle,
                child: widget.scaleAnimation != null
                    ? (ScaleTransition(
                        scale: widget.scaleAnimation!,
                        child: box,
                      ))
                    : box,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
