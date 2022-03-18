import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/model/kanswer.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/model/kquestion.dart';
import 'package:app_core/ui/game/service/kgame_controller.dart';
import 'package:app_core/ui/game/service/kgame_data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class KGameWordFortune extends StatefulWidget {
  static const GAME_ID = "516";
  static const GAME_APP_ID = "516";
  static const GAME_NAME = "word_fortune";

  final KGameController controller;
  final KHero? hero;
  final Function? onFinishLevel;

  const KGameWordFortune({
    Key? key,
    this.hero,
    this.onFinishLevel,
    required this.controller,
  }) : super(key: key);

  @override
  _KGameWordFortuneState createState() => _KGameWordFortuneState();
}

class _KGameWordFortuneState extends State<KGameWordFortune>
    with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  String? correctAudioFileUri;
  String? wrongAudioFileUri;

  late Animation<Offset> _bouncingAnimation;
  late Animation<double> _moveUpAnimation,
      _boxScaleAnimation,
      _correctTwinkleAnimation;

  late AnimationController _boxScaleAnimationController,
      _bouncingAnimationController,
      _moveUpAnimationController,
      _spinAnimationController,
      _correctTwinkleAnimationController;

  KGameData get gameData => widget.controller.value;

  bool isWrongAnswer = false;
  List<int>? twinkleBoxIndex;
  int? scaleBoxIndex;
  int? spinningAnswerIndex;
  bool? isShowStar = false;
  bool isAnswering = false;
  bool isPlaySound = false;
  List<double> barrierX = [0, 0, 0, 0];
  List<double> barrierY = [0, 0, 0, 0];
  List<KAnswer> barrierValues = [];

  bool get isStart => gameData.isStart ?? false;

  bool get isPause => gameData.isPause ?? false;

  bool get canAdvance => gameData.canAdvance ?? false;

  bool get isMuted => gameData.isMuted ?? false;

  int get point => gameData.point ?? 0;

  int get rightAnswerCount => gameData.rightAnswerCount ?? 0;

  int get wrongAnswerCount => gameData.wrongAnswerCount ?? 0;

  int get currentQuestionIndex => gameData.currentQuestionIndex ?? 0;

  int get currentLevel => gameData.currentLevel ?? 0;

  int get levelCount => gameData.levelCount ?? 0;

  int get eggReceive => gameData.eggReceive ?? 0;

  List<double> get levelHardness => gameData.levelHardness;

  List<KAnswer> get currentQuestionAnswers => gameData.currentQuestionAnswers;

  List<KQuestion> get questions => gameData.questions;

  KQuestion get currentQuestion => gameData.currentQuestion;

  List<String> correctAnswer = [];
  List<int?> selectedWordIndex = [];

  double get boxSize => ((MediaQuery.of(context).size.width - 20) / 6) - 10;

  int correctTwinkleTime = 2;

  @override
  void initState() {
    super.initState();

    loadAudioAsset();

    _correctTwinkleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 50), () {
            if (mounted) {
              this._correctTwinkleAnimationController.reverse();
            }
          });
        } else if (mounted && status == AnimationStatus.dismissed) {
          Future.delayed(Duration(milliseconds: 50), () {
            if (mounted) {
              if (correctTwinkleTime - 1 > 0) {
                this.setState(() {
                  correctTwinkleTime = correctTwinkleTime - 1;
                });
                this._correctTwinkleAnimationController.forward();
              } else {
                this.setState(() {
                  correctTwinkleTime = 2;
                  twinkleBoxIndex = null;
                });
              }
            }
          });
        }
      });
    _correctTwinkleAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _correctTwinkleAnimationController, curve: Curves.linear));

    _boxScaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 50), () {
            this._boxScaleAnimationController.reverse();
          });
        } else if (mounted && status == AnimationStatus.dismissed) {
          Future.delayed(Duration(milliseconds: 50), () {
            this.setState(() {
              scaleBoxIndex = null;
            });
          });
        }
      });
    _boxScaleAnimation = new Tween(
      begin: 1.0,
      end: 1.2,
    ).animate(new CurvedAnimation(
        parent: _boxScaleAnimationController, curve: Curves.bounceOut));

    _bouncingAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _bouncingAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              // _bouncingAnimationController.forward(from: 0.0);
              // this._heroScaleAnimationController.forward();
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
              Future.delayed(Duration(milliseconds: 50), () {
                if (mounted) {
                  this.setState(() {
                    spinningAnswerIndex = null;
                  });
                }
              });
              // this._heroScaleAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {}
          });

    _moveUpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {}
      });
    _moveUpAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _moveUpAnimationController, curve: Curves.bounceOut));

    getListAnswer();
  }

  @override
  void dispose() {
    _boxScaleAnimationController.dispose();
    _bouncingAnimationController.dispose();
    _moveUpAnimationController.dispose();
    _spinAnimationController.dispose();
    _correctTwinkleAnimationController.dispose();

    audioPlayer.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  void getListAnswer() {
    final answerList = currentQuestionAnswers;
    final correctAnswer = currentQuestion.correctAnswer?.text?.split("") ?? [];

    this.setState(() {
      this.barrierValues = answerList;
      this.correctAnswer = correctAnswer;
      this.selectedWordIndex =
          List.generate(correctAnswer.length, (index) => null);
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
    if (!isMuted) {
      try {
        if (isTrueAnswer) {
          await audioPlayer.play(correctAudioFileUri ?? "", isLocal: true);
        } else {
          await audioPlayer.play(wrongAudioFileUri ?? "", isLocal: true);
        }
      } catch (e) {}
    }
    this.setState(() {
      this.isPlaySound = false;
    });
  }

  void handlePickAnswer(KAnswer answer, int answerIndex) {
    if (isAnswering) {
      return;
    }

    this.setState(() {
      isAnswering = true;
    });

    if (KStringHelper.isExist(answer.text) &&
        correctAnswer.contains(answer.text!)) {
      this.setState(() {
        this.isPlaySound = true;
        for (int i = 0; i < correctAnswer.length; i++) {
          if (correctAnswer[i] == answer.text) {
            this.selectedWordIndex[i] = answerIndex;
            if (this.twinkleBoxIndex == null) this.twinkleBoxIndex = [];
            this.twinkleBoxIndex!.add(i);
          }
        }
      });
      playSound(true);
      this._correctTwinkleAnimationController.forward();

      if (selectedWordIndex.where((index) => index != null).length <
          correctAnswer.length) {
        this.setState(() {
          isAnswering = false;
        });
        return;
      }
    } else {
      this.setState(() {
        this.isPlaySound = true;
        spinningAnswerIndex = answerIndex;
      });
      playSound(false);
      this._spinAnimationController.reset();
      this._spinAnimationController.forward();

      if (mounted) {
        widget.controller.value.result = false;
        widget.controller.value.point = point > 0 ? point - 1 : 0;
        if (!isWrongAnswer) {
          widget.controller.value.wrongAnswerCount = wrongAnswerCount + 1;
          this.setState(() {
            isWrongAnswer = true;
          });
        }
        Future.delayed(Duration(milliseconds: 250), () {
          if (mounted) {
            this.setState(() {
              isAnswering = false;
            });
          }
        });
        widget.controller.notify();
      }
      return;
    }

    Future.delayed(Duration(milliseconds: 250), () {
      widget.controller.value.result = true;
      widget.controller.value.point = point + 5;
      if (!isWrongAnswer) {
        widget.controller.value.rightAnswerCount = rightAnswerCount + 1;
        this.setState(() {
          isShowStar = true;
        });
        if (!_moveUpAnimationController.isAnimating) {
          this._moveUpAnimationController.reset();
          this._moveUpAnimationController.forward();
        }
      }
      this.setState(() {
        isWrongAnswer = false;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          this.setState(() {
            isShowStar = false;
          });
          Future.delayed(Duration(milliseconds: 500), () {
            if (mounted) {
              this._moveUpAnimationController.reset();

              if (currentQuestionIndex + 1 < questions.length) {
                widget.controller.value.currentQuestionIndex =
                    currentQuestionIndex + 1;
                getListAnswer();
              } else {
                if (questions.length > 0 &&
                    (rightAnswerCount / questions.length) >=
                        levelHardness[currentLevel]) {
                  if (currentLevel == eggReceive)
                    widget.controller.value.eggReceive = eggReceive + 1;
                  widget.controller.value.canAdvance = true;
                }
                widget.controller.value.isStart = false;
                widget.controller.notify();

                if (widget.onFinishLevel != null) {
                  widget.onFinishLevel!();
                }
              }

              this.setState(() {
                isAnswering = false;
              });
            }
          });
        }
      });

      widget.controller.notify();
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 80,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  child: Text(
                    "${currentQuestion.text ?? ""}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 42,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              // bottomLeft
                              offset: Offset(-1, -1),
                              color: Colors.brown),
                          Shadow(
                              // bottomRight
                              offset: Offset(1, -1),
                              color: Colors.brown),
                          Shadow(
                              // topRight
                              offset: Offset(1, 1),
                              color: Colors.brown),
                          Shadow(
                              // topLeft
                              offset: Offset(-1, 1),
                              color: Colors.brown),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    barrierValues.length,
                    (i) => selectedWordIndex.contains(i)
                        ? SizedBox()
                        : GestureDetector(
                            onTap: () =>
                                this.handlePickAnswer(barrierValues[i], i),
                            child: Transform.rotate(
                              angle: spinningAnswerIndex == i
                                  ? -this._spinAnimationController.value *
                                      4 *
                                      Math.pi
                                  : 0,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                width: boxSize,
                                height: boxSize,
                                decoration: BoxDecoration(
                                  color: Color(0xff2c1c44),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: FittedBox(
                                  child: Text(
                                    "${barrierValues[i].text ?? ""}",
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
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 100,
            ),
            child: Transform.translate(
              offset: Offset(0, 0),
              child: Transform.translate(
                offset: Offset(0, -60 * _moveUpAnimation.value),
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
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 100,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(
                  selectedWordIndex.length,
                  (i) {
                    final selectedWordIndexItem = selectedWordIndex[i];
                    final selectedAnswer = selectedWordIndexItem != null
                        ? barrierValues[selectedWordIndexItem]
                        : null;

                    final boxColor = selectedAnswer != null
                        ? Color(0xff2c1c44)
                        : Colors.white;
                    final boxBorderColor = (selectedAnswer != null &&
                                (twinkleBoxIndex == null ||
                                    !twinkleBoxIndex!.contains(i))) ||
                            (twinkleBoxIndex != null &&
                                twinkleBoxIndex!.contains(i) &&
                                _correctTwinkleAnimation.value == 1.0)
                        ? Color(0xffFFD700)
                        : Color(0xff2c1c44);

                    final box = Container(
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      width: boxSize,
                      height: boxSize,
                      decoration: BoxDecoration(
                        color: boxColor,
                        border: Border(
                          top: BorderSide(
                            width: 2,
                            color: boxBorderColor,
                          ),
                          bottom: BorderSide(
                            width: 2,
                            color: boxBorderColor,
                          ),
                          left: BorderSide(
                            width: 2,
                            color: boxBorderColor,
                          ),
                          right: BorderSide(
                            width: 2,
                            color: boxBorderColor,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: selectedAnswer != null
                          ? FittedBox(
                              child: Text(
                                "${selectedAnswer.text ?? ""}",
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            )
                          : SizedBox(),
                    );

                    return scaleBoxIndex != null && scaleBoxIndex! == i
                        ? ScaleTransition(
                            scale: _boxScaleAnimation,
                            child: box,
                          )
                        : box;
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return body;
  }
}
