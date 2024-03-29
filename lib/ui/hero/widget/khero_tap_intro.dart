import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/style/ktheme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class KHeroTapIntro extends StatefulWidget {
  final Function(int)? onChangeLevel;
  final Function(int, int, bool)? onFinishLevel;
  final bool isShowEndLevel;
  final bool isMuted;
  final bool? isPause;

  const KHeroTapIntro({
    this.onChangeLevel,
    this.onFinishLevel,
    required this.isShowEndLevel,
    required this.isMuted,
    this.isPause,
  });

  @override
  _KHeroTapIntroState createState() => _KHeroTapIntroState();
}

class _KHeroTapIntroState extends State<KHeroTapIntro>
    with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  String? correctAudioFileUri;
  String? wrongAudioFileUri;

  late Animation _bouncingAnimation,
      _shakeTheTopLeftAnimation,
      _shakeTheTopRightAnimation;
  late Animation<double> _moveUpAnimation, _heroScaleAnimation;

  late AnimationController _heroScaleAnimationController,
      _bouncingAnimationController,
      _shakeTheTopLeftAnimationController,
      _shakeTheTopRightAnimationController,
      _moveUpAnimationController,
      _spinAnimationController;

  bool isShowPlusPoint = false;

  List<String> questionContents = [];
  List<int> rightAnswers = [];

  int currentQuestionIndex = 0;
  int? spinningHeroIndex;
  int? currentShowStarIndex;
  int consecutiveWrongAnswerCount = 0;
  int correctCount = 0;
  int questionCount = 0;
  int level = 0;
  bool isPlaySound = false;

  Math.Random rand = new Math.Random();

  List<int> barrierValues = [];

  List<int> get listAnswers => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
      .where((item) => item != (rightAnswers[currentQuestionIndex]))
      .toList();

  int get getRandomAnswer => listAnswers[rand.nextInt(listAnswers.length)];

  bool isMuted = true;
  bool isShowSadTamago = false;
  bool isGameOver = false;
  bool isAnimating = false;

  int tamagoJumpTimes = 0;

  double eggWidth = 90;
  double eggHeight = 90;

  int get correctPercent =>
      questionCount > 0 ? ((correctCount * 100) / questionCount).floor() : 0;

  bool? isLocalPause = true;

  bool get isPause => isLocalPause ?? widget.isPause ?? false;

  Timer? _timer;
  int BASE_TIME_TO_ANSWER = 3000;
  int baseTimeToAnswer = 0;
  int timeToAnswer = 0;

  @override
  void initState() {
    super.initState();

    this.baseTimeToAnswer = BASE_TIME_TO_ANSWER;
    this.timeToAnswer = BASE_TIME_TO_ANSWER;

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
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              this._bouncingAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              // _bouncingAnimationController.forward(from: 0.0);
              if (tamagoJumpTimes > 0) {
                this.setState(() {
                  this.tamagoJumpTimes = this.tamagoJumpTimes - 1;
                });
                this._bouncingAnimationController.forward();
              } else {
                this._bouncingAnimationController.stop(canceled: true);
                this._bouncingAnimationController.reset();
                // guestAnswer();
              }
            }
          });
    _bouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -10.0))
        .animate(_bouncingAnimationController);

    _spinAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (mounted && status == AnimationStatus.completed) {
              this._spinAnimationController.reset();
              this._heroScaleAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {}
          });

    _moveUpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    this._shakeTheTopRightAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          this._shakeTheTopRightAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {}
      });
    this._shakeTheTopRightAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(_shakeTheTopRightAnimationController);

    this._shakeTheTopLeftAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          this._shakeTheTopLeftAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {}
      });
    this._shakeTheTopLeftAnimation = Tween<double>(
      begin: 0,
      end: -0.1,
    ).animate(_shakeTheTopLeftAnimationController);

    loadGame();
  }

  loadGame() async {
    try {
      final response =
          await KServerHandler.getGames(gameID: "200", level: "$level");

      if (response.isSuccess &&
          response.games != null &&
          response.games!.length > 0) {
        final game = response.games![0];
        setState(() {
          if (level == 3) {
            level = 0;
          } else {
            level++;
          }
          this.questionContents =
              (game.qnas?[0].questions ?? []).map((e) => e.text ?? "").toList();
          this.rightAnswers = (game.qnas?[0].questions ?? [])
              .map((e) => int.tryParse(e.correctAnswer?.text ?? "0") ?? 0)
              .toList();
          isShowSadTamago = false;
          currentShowStarIndex = null;
          spinningHeroIndex = null;
          isAnimating = false;
          currentQuestionIndex = 0;
          timeToAnswer = baseTimeToAnswer;
          this.getListAnswer();
        });
        startCount();
        // Future.delayed(Duration(milliseconds: 400), getListAnswer);
      } else {
        KSnackBarHelper.error("Can not get game data");
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    _heroScaleAnimationController.dispose();
    _bouncingAnimationController.dispose();
    _moveUpAnimationController.dispose();
    _spinAnimationController.dispose();
    _shakeTheTopLeftAnimationController.dispose();
    _shakeTheTopRightAnimationController.dispose();

    audioPlayer.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  void startCount() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (!isPause && !isGameOver) {
        if (timeToAnswer > 0) {
          setState(() {
            timeToAnswer = timeToAnswer - 1;
          });
        } else if (timeToAnswer == 0 && !isAnimating) {
          _timer?.cancel();
          if (consecutiveWrongAnswerCount + 1 >= 3) {
            this.setState(() {
              this.isShowSadTamago = true;
              this.isGameOver = true;
              this.isAnimating = false;
            });
            return;
          }
          this.setState(() {
            this.isAnimating = true;
            this.isShowSadTamago = true;
            this.consecutiveWrongAnswerCount++;
          });
          this._bouncingAnimationController.forward();

          Future.delayed(Duration(milliseconds: 700), () {
            this.setState(() {
              this.tamagoJumpTimes = 0;
            });
            if (!isMuted && !isPlaySound) {
              this.setState(() {
                this.isPlaySound = true;
              });
              playSound(false);
            }

            this.setState(() {
              questionCount++;
            });

            if (currentQuestionIndex == 9) {
              loadGame();
            } else {
              this.setState(() {
                isShowSadTamago = false;
                currentShowStarIndex = null;
                spinningHeroIndex = null;
                currentQuestionIndex++;
                getListAnswer();
                isAnimating = false;
                timeToAnswer = baseTimeToAnswer;
              });
              startCount();
            }
          });
        }
      }
    });
  }

  void guestAnswer() {
    final answerIndex = rand.nextInt(2);

    if (answerIndex == 0) {
      this._shakeTheTopLeftAnimationController.forward();
    } else {
      this._shakeTheTopRightAnimationController.forward();
    }
  }

  void getListAnswer() {
    final currentRightAnswer = rightAnswers[currentQuestionIndex];

    this.setState(() {
      this.currentShowStarIndex = null;
      this.barrierValues = [
        currentRightAnswer,
        getRandomAnswer,
      ];
      this.barrierValues.shuffle();
    });
  }

  void loadAudioAsset() async {
    try {
      Directory tempDir = await getTemporaryDirectory();

      ByteData correctAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/correct.mp3");
      ByteData wrongAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/wrong.mp3");

      File correctAudioTempFile = File('${tempDir.path}/correct.mp3');
      await correctAudioTempFile
          .writeAsBytes(correctAudioFileData.buffer.asUint8List(), flush: true);

      File wrongAudioTempFile = File('${tempDir.path}/wrong.mp3');
      await wrongAudioTempFile
          .writeAsBytes(wrongAudioFileData.buffer.asUint8List(), flush: true);

      this.setState(() {
        this.correctAudioFileUri = correctAudioTempFile.uri.toString();
        this.wrongAudioFileUri = wrongAudioTempFile.uri.toString();
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

  void handlePickAnswer(int answer, int answerIndex) {
    if (isAnimating || isPause || isGameOver) {
      return;
    }

    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    this.setState(() {
      isAnimating = true;
    });

    this._bouncingAnimationController.forward();
    bool isTrueAnswer = answer == rightAnswers[currentQuestionIndex];

    // Future.delayed(Duration(milliseconds: 400), () {
    if (answerIndex == 0) {
      this._shakeTheTopLeftAnimationController.forward();
    } else {
      this._shakeTheTopRightAnimationController.forward();
    }

    Future.delayed(Duration(milliseconds: 500), () {
      this.setState(() {
        this.tamagoJumpTimes = 0;
      });
      if (!isMuted && !isPlaySound) {
        this.setState(() {
          this.isPlaySound = true;
        });
        playSound(isTrueAnswer);
      }

      this.setState(() {
        spinningHeroIndex = answerIndex;
      });
      this._spinAnimationController.reset();
      this._spinAnimationController.forward();

      if (isTrueAnswer) {
        this.setState(() {
          questionCount++;
          correctCount++;
          consecutiveWrongAnswerCount = 0;
          currentShowStarIndex = answerIndex;
          if (!_moveUpAnimationController.isAnimating) {
            this._moveUpAnimationController.reset();
            this._moveUpAnimationController.forward();
          }
        });
      } else {
        if (consecutiveWrongAnswerCount + 1 >= 3) {
          this.setState(() {
            this.isShowSadTamago = true;
            this.isGameOver = true;
            this.isAnimating = false;
          });
          return;
        } else {
          this.setState(() {
            questionCount++;
            consecutiveWrongAnswerCount++;
            this.isShowSadTamago = true;
          });
        }
      }
      if (currentQuestionIndex == 9) {
        loadGame();
      } else {
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            final baseTime =
                (baseTimeToAnswer - 0.1 * baseTimeToAnswer).floor();
            this.setState(() {
              isShowSadTamago = false;
              currentShowStarIndex = null;
              spinningHeroIndex = null;
              currentQuestionIndex++;
              getListAnswer();
              isAnimating = false;
              if (baseTime > 0 && isTrueAnswer) {
                baseTimeToAnswer = baseTime;
                timeToAnswer = baseTime;
              } else {
                timeToAnswer = baseTimeToAnswer;
              }
            });
            startCount();
          }
        });
      }
    });
    // });
  }

  void toggleBackgroundSound() {
    if (this.isMuted) {
      this.setState(() {
        this.isMuted = false;
      });
    } else {
      this.setState(() {
        this.isMuted = true;
      });
    }
  }

  void restartGame() {
    this.setState(() {
      this.isAnimating = false;
      this.isPlaySound = false;
      this.isGameOver = false;
      this.currentQuestionIndex = 0;
      this.currentShowStarIndex = null;
      this.spinningHeroIndex = null;
      this.consecutiveWrongAnswerCount = 0;
      this.questionCount = 0;
      this.correctCount = 0;
      this.level = 0;
      this.isPlaySound = false;
      this.isShowPlusPoint = false;
      this.questionContents = [];
      this.rightAnswers = [];
      this.barrierValues = [];
      this.isMuted = true;
      this.isShowSadTamago = false;
      this.tamagoJumpTimes = 0;
      this.isLocalPause = null;
      this.baseTimeToAnswer = BASE_TIME_TO_ANSWER;
      this.timeToAnswer = BASE_TIME_TO_ANSWER;
      loadGame();
    });
  }

  void togglePauseLocal() {
    if (this.isLocalPause != null) {
      setState(() {
        this.isLocalPause = null;
      });
    } else {
      setState(() {
        this.isLocalPause = true;
      });
    }
  }

  String getRateString() {
    if (correctCount >= 30) {
      return "Genius";
    } else if (correctCount >= 20) {
      return "Great";
    } else if (correctCount >= 10) {
      return "Good";
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      fit: StackFit.expand,
      children: [
        barrierValues.length > 1
            ? Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isGameOver)
                      Text(
                        "GAME OVER",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (!isGameOver)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: LinearProgressIndicator(
                          value: (baseTimeToAnswer - timeToAnswer) /
                              baseTimeToAnswer,
                          backgroundColor: KTheme.of(context).lightGrey,
                          minHeight: 8,
                        ),
                      ),
                    // Text(
                    //   "${timeToAnswer}",
                    //   textScaleFactor: 1.0,
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 70,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                questionContents[currentQuestionIndex],
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (!isGameOver)
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
                                (this.isLocalPause ?? false)
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                color: Color(0xff2c1c44),
                                size: 30,
                              ),
                            ),
                            onTap: () => this.togglePauseLocal(),
                          ),
                        if (isGameOver)
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
                                Icons.refresh,
                                color: Color(0xff2c1c44),
                                size: 30,
                              ),
                            ),
                            onTap: () => this.restartGame(),
                          ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Barrier(
                          value: barrierValues[0],
                          barrierY: 0,
                          rotateAngle: spinningHeroIndex == 0
                              ? -this._spinAnimationController.value *
                                  4 *
                                  Math.pi
                              : 0,
                          bouncingAnimation: spinningHeroIndex == 0
                              ? _bouncingAnimation.value
                              : Offset(0, 0),
                          scaleAnimation: spinningHeroIndex == 0
                              ? _heroScaleAnimation
                              : null,
                          starY: _moveUpAnimation.value,
                          isShowStar: currentShowStarIndex == 0,
                          onTap: () =>
                              this.handlePickAnswer(barrierValues[0], 0),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Container(
                          transform: Matrix4.rotationZ(
                              _shakeTheTopRightAnimation.value * Math.pi),
                          transformAlignment: Alignment.bottomCenter,
                          width: eggWidth,
                          height: eggHeight,
                          child: Container(
                            transform: Matrix4.rotationZ(
                                _shakeTheTopLeftAnimation.value * Math.pi),
                            transformAlignment: Alignment.bottomCenter,
                            width: eggWidth,
                            height: eggHeight,
                            child: Transform.translate(
                              offset: currentShowStarIndex == null
                                  ? _bouncingAnimation.value
                                  : Offset(0, 0),
                              child: Image.asset(
                                isShowSadTamago
                                    ? KAssets.IMG_TAMAGO_CHAN_SAD
                                    : KAssets.IMG_TAMAGO_CHAN,
                                width: eggWidth,
                                height: eggHeight,
                                package: 'app_core',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        _Barrier(
                          value: barrierValues[1],
                          barrierY: 0,
                          rotateAngle: spinningHeroIndex == 1
                              ? -this._spinAnimationController.value *
                                  4 *
                                  Math.pi
                              : 0,
                          bouncingAnimation: spinningHeroIndex == 1
                              ? _bouncingAnimation.value
                              : Offset(0, 0),
                          scaleAnimation: spinningHeroIndex == 1
                              ? _heroScaleAnimation
                              : null,
                          starY: _moveUpAnimation.value,
                          isShowStar: currentShowStarIndex == 1,
                          onTap: () =>
                              this.handlePickAnswer(barrierValues[1], 1),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 15),
                                child: Text(
                                  "${correctCount}",
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Text(
                                isGameOver
                                    ? getRateString()
                                    : "${correctPercent}%",
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          child: InkWell(
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
                                this.isMuted
                                    ? Icons.volume_off
                                    : Icons.volume_up,
                                color: Color(0xff2c1c44),
                                size: 30,
                              ),
                            ),
                            onTap: () => this.toggleBackgroundSound(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );

    return body;
  }
}

class _Barrier extends StatelessWidget {
  final double rotateAngle;
  final double barrierY;
  final Animation<double>? scaleAnimation;
  final int value;
  final Offset bouncingAnimation;
  final double? starY;
  final Function onTap;
  final bool? isShowStar;

  _Barrier({
    required this.rotateAngle,
    this.scaleAnimation,
    required this.barrierY,
    required this.value,
    required this.bouncingAnimation,
    required this.onTap,
    this.starY,
    this.isShowStar,
  });

  @override
  Widget build(context) {
    final box = Container(
      width: 60,
      height: 60,
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
            fontSize: 40,
          ),
        ),
      ),
    );

    return Container(
      alignment: Alignment(barrierY, 0),
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          width: 60,
          height: 60,
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
                        size: 40,
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
      ),
    );
  }
}
