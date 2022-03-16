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

final GlobalKey _draggableKey = GlobalKey();

class KGameWord extends StatefulWidget {
  static const GAME_ID = "513";
  static const GAME_APP_ID = "513";
  static const GAME_NAME = "word";

  final KGameController controller;
  final KHero? hero;
  final Function? onFinishLevel;

  const KGameWord({
    Key? key,
    this.hero,
    this.onFinishLevel,
    required this.controller,
  }) : super(key: key);

  @override
  _KGameWordState createState() => _KGameWordState();
}

class _KGameWordState extends State<KGameWord> with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  String? correctAudioFileUri;
  String? wrongAudioFileUri;

  late Animation<Offset> _bouncingAnimation;
  late Animation<double> _moveUpAnimation, _heroScaleAnimation;

  late AnimationController _heroScaleAnimationController,
      _bouncingAnimationController,
      _moveUpAnimationController,
      _spinAnimationController;

  KGameData get gameData => widget.controller.value;

  bool isWrongAnswer = false;
  int? spinningHeroIndex;
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

  @override
  void initState() {
    super.initState();

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
    _heroScaleAnimationController.dispose();
    _bouncingAnimationController.dispose();
    _moveUpAnimationController.dispose();
    _spinAnimationController.dispose();

    audioPlayer.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  void getListAnswer() {
    final answerList = currentQuestionAnswers;
    final correctAnswer = answerList
        .where((answer) => answer.isCorrect ?? false)
        .map((answer) => answer.text ?? "")
        .toList();
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

  void handlePickAnswer(KAnswer answer, int answerIndex, int boxIndex) {
    if (isAnswering) {
      return;
    }

    this.setState(() {
      isAnswering = true;
    });

    if (KStringHelper.isExist(answer.text) &&
        correctAnswer.contains(answer.text!) &&
        correctAnswer.indexOf(answer.text!) == boxIndex) {
      this.setState(() {
        selectedWordIndex[boxIndex] = answerIndex;
        this.isPlaySound = true;
      });
      playSound(true);

      if (selectedWordIndex.where((index) => index != null).length < correctAnswer.length) {
        this.setState(() {
          isAnswering = false;
        });
        return;
      }
    } else {
      this.setState(() {
        this.isPlaySound = true;
      });
      playSound(false);

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
      return;
    }

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
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                barrierValues.length,
                (i) => selectedWordIndex.contains(i)
                    ? SizedBox()
                    : Draggable(
                        data: i,
                        dragAnchorStrategy: pointerDragAnchorStrategy,
                        feedback: DraggingAnswerItem(
                          dragKey: _draggableKey,
                          answer: barrierValues[i],
                        ),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          width: 60,
                          height: 60,
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
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 80,
            ),
            child: Transform.translate(
              offset: Offset(0, 0),
              child: Transform.translate(
                offset: Offset(0, -60 * _moveUpAnimation.value),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: (isShowStar ?? false)
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
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 80,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              child: Column(
                children: [
                  Text(
                    "${currentQuestion.text ?? ""}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                        shadows: [
                          Shadow( // bottomLeft
                              offset: Offset(-1, -1),
                              color: Colors.black
                          ),
                          Shadow( // bottomRight
                              offset: Offset(1, -1),
                              color: Colors.black
                          ),
                          Shadow( // topRight
                              offset: Offset(1, 1),
                              color: Colors.black
                          ),
                          Shadow( // topLeft
                              offset: Offset(-1, 1),
                              color: Colors.black
                          ),
                        ]
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      selectedWordIndex.length,
                      (i) => DragTarget(
                        builder: (context, _, __) {
                          final selectedWordIndexItem = selectedWordIndex[i];
                          final selectedAnswer = selectedWordIndexItem != null
                              ? barrierValues[selectedWordIndexItem]
                              : null;
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            width: 60,
                            height: 60,
                            decoration: selectedAnswer != null
                                ? BoxDecoration(
                                    color: Color(0xff2c1c44),
                                    borderRadius: BorderRadius.circular(5),
                                  )
                                : BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      top: BorderSide(
                                        width: 2,
                                        color: Color(0xff2c1c44),
                                      ),
                                      bottom: BorderSide(
                                        width: 2,
                                        color: Color(0xff2c1c44),
                                      ),
                                      left: BorderSide(
                                        width: 2,
                                        color: Color(0xff2c1c44),
                                      ),
                                      right: BorderSide(
                                        width: 2,
                                        color: Color(0xff2c1c44),
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
                        },
                        onAccept: (int answerIndex) {
                          print(answerIndex);
                          if (barrierValues.length > answerIndex) {
                            final answer = barrierValues[answerIndex];
                            handlePickAnswer(answer, answerIndex, i);
                          }
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

    return body;
  }
}

class DraggingAnswerItem extends StatelessWidget {
  const DraggingAnswerItem({
    Key? key,
    required this.dragKey,
    required this.answer,
  }) : super(key: key);

  final KAnswer answer;
  final GlobalKey dragKey;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: Container(
        width: 65,
        height: 65,
        key: dragKey,
        child: Opacity(
          opacity: 0.85,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xff2c1c44),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FittedBox(
              child: Text(
                "${answer.text ?? ""}",
                textScaleFactor: 1.0,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
