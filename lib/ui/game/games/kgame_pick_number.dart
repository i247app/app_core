import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui';

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

class KGamePickNumber extends StatefulWidget {
  static const GAME_ID = "518";
  static const GAME_APP_ID = "518";
  static const GAME_NAME = "pick_number";

  final KGameController controller;
  final KHero? hero;
  final Function? onFinishLevel;

  const KGamePickNumber({
    Key? key,
    this.hero,
    this.onFinishLevel,
    required this.controller,
  }) : super(key: key);

  @override
  _KGamePickNumberState createState() => _KGamePickNumberState();
}

class _KGamePickNumberState extends State<KGamePickNumber>
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
  int wrongCount = 0;
  int maxWrongCountAccept = 3;
  int wrongCountShowHint = 2;

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

  List<int> questionRows = [1, 2, 3, 3];
  List<String> correctOrderAnswers = [];
  List<String> answers = [];
  List<int?> wrongSelectedWordIndex = [];

  double get boxSize => ((MediaQuery.of(context).size.width - 20) / 6) - 10;

  int correctTwinkleTime = 2;

  int showPyramidLevel = 1;
  int hardLevel = 2;
  int superHardLevel = 3;

  bool get isShowPyramid =>
      (widget.controller.value.currentLevel ?? 0) >= showPyramidLevel;

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
                    if ((widget.controller.value.currentLevel ?? 0) <
                        superHardLevel) {
                      print(answers);
                      print(barrierValues[spinningAnswerIndex!].text);
                      print(answers
                          .indexOf(barrierValues[spinningAnswerIndex!].text!));
                      if (!answers.contains(
                              barrierValues[spinningAnswerIndex!].text) ||
                          answers.indexOf(
                                  barrierValues[spinningAnswerIndex!].text!) <
                              answers.length - 1) {
                        wrongSelectedWordIndex.add(spinningAnswerIndex);
                      }
                    } else {
                      // print(answers);
                      // print(barrierValues[spinningAnswerIndex!].text);
                      // if (answers
                      //     .contains(barrierValues[spinningAnswerIndex!].text)) {
                      //   wrongSelectedWordIndex.add(spinningAnswerIndex);
                      // }
                    }
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

    getQuestion();
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

  void getQuestion() {
    int startNumber = 1;
    int endNumber = 9;

    this.setState(() {
      for (int i = startNumber; i <= endNumber; i++) {
        correctOrderAnswers.add(i.toString());
      }
    });

    print(
        "widget.controller.value.currentLevel ${startNumber} ${endNumber} ${correctOrderAnswers}");
    this.getListAnswer();
  }

  void getListAnswer() {
    int totalDisplayAnswer = 3;
    if ((widget.controller.value.currentLevel ?? 0) >= hardLevel) {
      totalDisplayAnswer = 5;
    }
    if ((widget.controller.value.currentLevel ?? 0) >= superHardLevel) {
      totalDisplayAnswer = correctOrderAnswers.length;
    }

    int currentAnswerIndex = answers.length;
    List<String> _tmpDisplayAnswers = [];

    if (currentAnswerIndex < correctOrderAnswers.length) {
      String currentAnswer = correctOrderAnswers[currentAnswerIndex];
      _tmpDisplayAnswers.add(currentAnswer);
      List<String> _tmpAnswers =
          correctOrderAnswers.where((e) => e != currentAnswer).toList();

      for (int i = 0; i < totalDisplayAnswer - 1; i++) {
        final answer = _tmpAnswers[Math.Random().nextInt(_tmpAnswers.length)];
        _tmpAnswers.remove(answer);
        _tmpDisplayAnswers.add(answer);
      }

      _tmpDisplayAnswers.shuffle();
      print(_tmpDisplayAnswers);
      this.setState(() {
        this.wrongSelectedWordIndex = [];
        this.barrierValues =
            _tmpDisplayAnswers.map((e) => new KAnswer()..text = e).toList();
      });
    }
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

  void handleShowHint() {
    KAnswer? answer;
    int? answerIndex;

    this.setState(() {
      wrongCount = 0;
    });
    // for (int i = 0; i < barrierValues.length; i++) {
    //   if (correctAnswer.contains(barrierValues[i].text ?? "") &&
    //       !this.selectedWordIndex.contains(i) &&
    //       answer == null &&
    //       answerIndex == null) {
    //     answer = barrierValues[i];
    //     answerIndex = i;
    //   }
    // }
    // for (int i = 0; i < correctAnswer.length; i++) {
    //   if (correctAnswer[i] == answer?.text) {
    //     this.setState(() {
    //       this.selectedWordIndex[i] = answerIndex;
    //       if (this.twinkleBoxIndex == null) this.twinkleBoxIndex = [];
    //       this.twinkleBoxIndex!.add(i);
    //     });
    //   }
    // }
    this._correctTwinkleAnimationController.forward();
  }

  void handlePickAnswer(KAnswer answer, int answerIndex) {
    if (isAnswering || !KStringHelper.isExist(answer.text)) {
      return;
    }

    bool isTrueAnswer =
        correctOrderAnswers.indexOf(answer.text!) == answers.length;

    if (!isPlaySound) {
      this.setState(() {
        this.isPlaySound = true;
      });
      playSound(isTrueAnswer);
    }

    this.setState(() {
      isAnswering = true;
      spinningAnswerIndex = answerIndex;
    });
    this._spinAnimationController.reset();
    this._spinAnimationController.forward();

    if (isTrueAnswer) {
      this.setState(() {
        this.answers.add(answer.text!);
      });
      widget.controller.value.result = true;
      widget.controller.value.point = point + 5;

      if (!isWrongAnswer) {
        widget.controller.value.rightAnswerCount = rightAnswerCount + 1;
        this.setState(() {
          isShowStar = true;
          if (this.twinkleBoxIndex == null) this.twinkleBoxIndex = [];
          this.twinkleBoxIndex!.add(correctOrderAnswers.indexOf(answer.text!));
        });
        if (!_moveUpAnimationController.isAnimating) {
          this._moveUpAnimationController.reset();
          this._moveUpAnimationController.forward();
        }
        this._correctTwinkleAnimationController.forward();
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
              this._correctTwinkleAnimationController.reset();

              if (answers.length == correctOrderAnswers.length) {
                if (currentLevel == eggReceive)
                  widget.controller.value.eggReceive = eggReceive + 1;
                widget.controller.value.canAdvance = true;

                widget.controller.value.isStart = false;
                widget.controller.notify();

                if (widget.onFinishLevel != null) {
                  widget.onFinishLevel!();
                }
              } else if ((widget.controller.value.currentLevel ?? 0) <
                  superHardLevel) {
                this.getListAnswer();
              }

              this.setState(() {
                isAnswering = false;
              });
            }
          });
        }
      });
    } else {
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
    }
    widget.controller.notify();
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
                SizedBox(
                  height: 32,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    barrierValues.length,
                    (i) => wrongSelectedWordIndex.contains(i)
                        ? SizedBox()
                        : GestureDetector(
                            onTap: answers.contains(barrierValues[i].text!)
                                ? null
                                : () =>
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
                                  color: answers.contains(
                                              barrierValues[i].text!) &&
                                          (widget.controller.value
                                                      .currentLevel ??
                                                  0) >=
                                              superHardLevel
                                      ? Colors.orange
                                      : Color(0xff2c1c44),
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
              top: 70,
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
              top: 70,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              child: Column(
                children: List.generate(isShowPyramid ? questionRows.length : 1,
                    (index) {
                  int startIndex = index > 0
                      ? questionRows
                          .take(index)
                          .reduce((value, element) => value + element)
                      : 0;
                  int endIndex = questionRows
                          .take(index + 1)
                          .reduce((value, element) => value + element) -
                      1;

                  if (!isShowPyramid) {
                    startIndex = 0;
                    endIndex = correctOrderAnswers.length - 1;
                  }

                  if (startIndex < 0 ||
                      endIndex >= correctOrderAnswers.length) {
                    return Container();
                  }

                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      endIndex - startIndex + 1,
                      (boxIndex) {
                        final i = startIndex + boxIndex;
                        final selectedAnswer =
                            answers.length > i ? answers[i] : null;

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
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                                    "${selectedAnswer}",
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
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );

    return body;
  }
}
