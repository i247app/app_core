import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:typed_data';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kimage_animation_helper.dart';
import 'package:app_core/helper/koverlay_helper.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/ui/hero/widget/khero_game_count_down_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_end.dart';
import 'package:app_core/ui/hero/widget/khero_game_highscore_dialog.dart';
import 'package:app_core/ui/hero/widget/khero_game_pause_dialog.dart';
import 'package:app_core/ui/hero/widget/ktamago_chan_jumping.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/header/kassets.dart';
import 'package:path_provider/path_provider.dart';

class KHeroTapGame extends StatefulWidget {
  final KHero? hero;

  const KHeroTapGame({this.hero});

  @override
  _KHeroTapGameState createState() => _KHeroTapGameState();
}

class _KHeroTapGameState extends State<KHeroTapGame> {
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

  List<int> levelHighscores = [];

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
    final heroGameLevel = KTamagoChanJumping(onFinish: onFinish);
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
            scores: levelHighscores,
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
            child: SafeArea(
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
                    child: KTapGameScreen(
                      hero: widget.hero,
                      totalLevel: totalLevel,
                      isShowEndLevel: isShowEndLevel,
                      onFinishLevel: (level, score, isHaveWrongAnswer) {
                        if (level < totalLevel) {
                          print(isHaveWrongAnswer);
                          if (!isHaveWrongAnswer) {
                            this.setState(() {
                              this.levelHighscores.add(score);
                            });
                          }
                          this.showHeroGameLevelOverlay(
                            () {
                              if (this.overlayID != null) {
                                KOverlayHelper.removeOverlay(this.overlayID!);
                                this.overlayID = null;
                              }
                              this.showHeroGameHighscoreOverlay(() {
                                this.setState(() {
                                  this.isShowEndLevel = false;
                                });
                                if (this.overlayID != null) {
                                  KOverlayHelper.removeOverlay(this.overlayID!);
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
                              KOverlayHelper.removeOverlay(this.overlayID!);
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

class KTapGameScreen extends StatefulWidget {
  final KHero? hero;
  final Function(int)? onChangeLevel;
  final Function? onFinishLevel;
  final bool isShowEndLevel;
  final int? totalLevel;

  const KTapGameScreen({
    this.hero,
    this.onChangeLevel,
    this.onFinishLevel,
    this.totalLevel,
    required this.isShowEndLevel,
  });

  @override
  _KTapGameScreenState createState() => _KTapGameScreenState();
}

class _KTapGameScreenState extends State<KTapGameScreen>
    with TickerProviderStateMixin {
  AudioPlayer backgroundAudioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  String? correctAudioFileUri;
  String? wrongAudioFileUri;
  String? backgroundAudioFileUri;

  late Animation<Offset> _bouncingAnimation;
  late Animation<double> _moveUpAnimation, _heroScaleAnimation;

  late AnimationController _heroScaleAnimationController,
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

  List<String> get questions => levelQuestions[currentLevel];

  List<int> get rightAnswers => levelRightAnswers[currentLevel];
  int currentQuestionIndex = 0;
  int? spinningHeroIndex;
  int? currentShowStarIndex;
  bool isPlaySound = false;

  List<double> barrierX = [0, 0, 0, 0];
  List<double> barrierY = [0, 0, 0, 0];

  Math.Random rand = new Math.Random();

  int get getRandomAnswer => rightAnswers[currentQuestionIndex] <= 4
      ? (rand.nextInt(4) + rightAnswers[currentQuestionIndex])
      : (rand.nextInt(4) + rightAnswers[currentQuestionIndex] - 3);

  bool get canRestartGame =>
      currentLevel + 1 < totalLevel ||
      (currentLevel < totalLevel &&
          (rightAnswerCount / questions.length) < levelHardness[currentLevel]);

  List<int> barrierValues = [];
  double topBoundary = -2.1;

  int? overlayID;
  bool isPause = false;
  bool isBackgroundSoundPlaying = false;

  @override
  void initState() {
    super.initState();

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
          this.setState(() {
            isShowPlusPoint = false;
          });
          Future.delayed(Duration(milliseconds: 50), () {
            this._moveUpAnimationController.reset();
          });
        }
      });
    _moveUpAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _moveUpAnimationController, curve: Curves.bounceOut));

    // this.screenHeight = MediaQuery.of(context).size.height;
    // this.screenWidth = MediaQuery.of(context).size.width;

    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (isStart && mounted && !isPause) {
        if (currentLevel < totalLevel) {
          this.setState(() {
            this.levelPlayTimes[currentLevel] += 1;
          });
        }
      }
    });

    randomBoxPosition();
    getListAnswer();
  }

  @override
  void dispose() {
    _timer?.cancel();
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

  void getListAnswer() {
    final currentRightAnswer = rightAnswers[currentQuestionIndex];

    this.setState(() {
      this.currentShowStarIndex = null;
      if (currentRightAnswer <= 4) {
        this.barrierValues = [
          currentRightAnswer,
          currentRightAnswer + 1,
          currentRightAnswer + 2,
          currentRightAnswer + 3,
        ];
        this.barrierValues.shuffle();
      } else {
        this.barrierValues = [
          currentRightAnswer,
          currentRightAnswer - 1,
          currentRightAnswer - 2,
          currentRightAnswer - 3,
        ];
        this.barrierValues.shuffle();
      }
    });
  }

  void randomBoxPosition() {
    Math.Random rand = new Math.Random();
    //rand.nextDouble() * (max - min) + min
    double topLeftX = rand.nextDouble() * (-0.3 - -1) + -1;
    double topLeftY = rand.nextDouble() * (-0.3 - -0.8) - 0.8;
    double topRightX = rand.nextDouble() * (1 - 0.3) + 0.3;
    double topRightY = rand.nextDouble() * (-0.3 - -0.8) - 0.8;
    double bottomLeftX = rand.nextDouble() * (-0.3 - -1) + -1;
    double bottomLeftY = rand.nextDouble() * (0.8 - 0.3) + 0.3;
    double bottomRightX = rand.nextDouble() * (1 - 0.3) + 0.3;
    double bottomRightY = rand.nextDouble() * (0.8 - 0.3) + 0.3;
    barrierX[0] = topLeftX;
    barrierY[0] = topLeftY;
    barrierX[1] = topRightX;
    barrierY[1] = topRightY;
    barrierX[2] = bottomLeftX;
    barrierY[2] = bottomLeftY;
    barrierX[3] = bottomRightX;
    barrierY[3] = bottomRightY;
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

  void handlePickAnswer(int answer, int answerIndex) {
    bool isTrueAnswer = answer == rightAnswers[currentQuestionIndex];

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
        if (mounted && currentQuestionIndex + 1 < questions.length) {
          this.setState(() {
            currentQuestionIndex = currentQuestionIndex + 1;
            randomBoxPosition();
            getListAnswer();
          });
          Future.delayed(Duration(milliseconds: 50), () {
            this.setState(() {
              isScroll = true;
            });
          });
        } else {
          this.setState(() {
            if (rightAnswerCount / questions.length >=
                levelHardness[currentLevel]) {
              eggReceive = eggReceive + 1;
              if (currentLevel + 1 < totalLevel) {
                canAdvance = true;
                if (widget.onFinishLevel != null) {
                  widget.onFinishLevel!(currentLevel + 1, levelPlayTimes[currentLevel], wrongAnswerCount > 0);
                }
              }
            }
            isStart = false;
            randomBoxPosition();
            getListAnswer();
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
    if (currentLevel + 1 < levelHardness.length &&
        (rightAnswerCount / questions.length) >= levelHardness[currentLevel]) {
      this.setState(() {
        if (widget.onChangeLevel != null)
          widget.onChangeLevel!(currentLevel + 1);
        currentLevel += 1;
      });
    }
    this.setState(() {
      this.isPlaySound = false;
      this.isStart = true;
      this.isScroll = true;
      this.isShooting = false;
      this.result = null;
      this.points = 0;
      this.currentQuestionIndex = 0;
      this.spinningHeroIndex = null;
      randomBoxPosition();
      getListAnswer();
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
        if (isStart || result != null)
          Align(
            alignment: Alignment(-1, -1),
            child: currentLevel < totalLevel
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
        if (!isStart)
          GestureDetector(
              onTap: (isShowCountDown || widget.isShowEndLevel || isPause)
                  ? () {}
                  : (result == null
                      ? start
                      : (canRestartGame ? restartGame : () {}))),
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
                      if (currentLevel < levelIconAssets.length &&
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
                children: [
                  ...List.generate(
                    barrierValues.length,
                    (i) => _Barrier(
                      onTap: (int answer) => handlePickAnswer(answer, i),
                      barrierX: barrierX[i],
                      barrierY: barrierY[i],
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
        ],
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
  final double barrierX;
  final double barrierY;
  final double rotateAngle;
  final Animation<double>? scaleAnimation;
  final int value;
  final Offset bouncingAnimation;
  final double? starY;
  final bool? isShowStar;
  final Function(int value) onTap;

  _Barrier({
    required this.barrierX,
    required this.barrierY,
    required this.rotateAngle,
    this.scaleAnimation,
    required this.value,
    required this.bouncingAnimation,
    this.starY,
    this.isShowStar,
    required this.onTap,
  });

  @override
  Widget build(context) {
    final box = InkWell(
      onTap: () {
        onTap(value);
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
    );

    return Container(
      alignment: Alignment(barrierX, barrierY),
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
                  offset: Offset(0, -60 * (starY ?? 0)),
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
            Transform.translate(
              offset: bouncingAnimation,
              child: Transform.rotate(
                angle: rotateAngle,
                child: scaleAnimation != null
                    ? (ScaleTransition(
                        scale: scaleAnimation!,
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
