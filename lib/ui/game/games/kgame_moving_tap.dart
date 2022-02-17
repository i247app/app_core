import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/model/kanswer.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/model/kquestion.dart';
import 'package:app_core/ui/game/service/kgame_controller.dart';
import 'package:app_core/ui/game/service/kgame_data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class KGameMovingTap extends StatefulWidget {
  static const GAME_ID = "510";
  static const GAME_NAME = "moving_tap";

  final KGameController controller;
  final KHero? hero;
  final Function? onFinishLevel;

  const KGameMovingTap({
    Key? key,
    this.hero,
    this.onFinishLevel,
    required this.controller,
  }) : super(key: key);

  @override
  _KGameMovingTapState createState() => _KGameMovingTapState();
}

class _KGameMovingTapState extends State<KGameMovingTap>
    with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  String? correctAudioFileUri;
  String? wrongAudioFileUri;

  late Animation<Offset> _bouncingAnimation;
  late Animation<double> _moveUpAnimation, _heroScaleAnimation;

  late AnimationController _barrierMovingAnimationController,
      _heroScaleAnimationController,
      _bouncingAnimationController,
      _moveUpAnimationController,
      _spinAnimationController;

  Timer? _timer;

  KGameData get gameData => widget.controller.value;

  bool isWrongAnswer = false;
  int? spinningHeroIndex;
  int? currentShowStarIndex;
  bool isAnswering = false;
  bool isPlaySound = false;
  List<double> barrierX = [0, 0, 0, 0];
  List<double> barrierY = [0, 0, 0, 0];
  List<KAnswer> barrierValues = [];
  List<bool> barrierOutSide = [false, false, false, false];

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

    _barrierMovingAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

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
  void dispose() {
    _timer?.cancel();
    _barrierMovingAnimationController.dispose();
    _heroScaleAnimationController.dispose();
    _bouncingAnimationController.dispose();
    _moveUpAnimationController.dispose();
    _spinAnimationController.dispose();

    audioPlayer.dispose();

    // TODO: implement dispose
    super.dispose();
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
      this.barrierValues.shuffle();
    });
  }

  void randomBoxPosition() {
    Math.Random rand = new Math.Random();
    //rand.nextDouble() * (max - min) + min
    double topLeftX = rand.nextDouble() * (-1.5 - -1.3) + -1.3;
    double topLeftY = rand.nextDouble() * (-1.5 - -1.3) + -1.3;
    double topRightX = rand.nextDouble() * (1.5 - 1.3) + 1.3;
    double topRightY = rand.nextDouble() * (-1.5 - -1.3) + -1.3;
    double bottomLeftX = rand.nextDouble() * (-1.5 - -1.3) + -1.3;
    double bottomLeftY = rand.nextDouble() * (1.5 - 1.3) + 1.3;
    double bottomRightX = rand.nextDouble() * (1.5 - 1.3) + 1.3;
    double bottomRightY = rand.nextDouble() * (1.5 - 1.3) + 1.3;
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
    bool isTrueAnswer = answer.isCorrect ?? false;

    if (!isPlaySound) {
      this.setState(() {
        this.isPlaySound = true;
      });
      playSound(isTrueAnswer);
    }

    this.setState(() {
      isAnswering = true;
      spinningHeroIndex = answerIndex;
    });
    this._spinAnimationController.reset();
    this._spinAnimationController.forward();

    if (isTrueAnswer) {
      widget.controller.value.result = true;
      widget.controller.value.point = point + 5;
      if (!isWrongAnswer) {
        widget.controller.value.rightAnswerCount = rightAnswerCount + 1;
        this.setState(() {
          currentShowStarIndex = answerIndex;
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
            currentShowStarIndex = null;
          });
          Future.delayed(Duration(milliseconds: 500), () {
            if (mounted) {
              this._moveUpAnimationController.reset();

              if (currentQuestionIndex + 1 < questions.length) {
                widget.controller.value.currentQuestionIndex =
                    currentQuestionIndex + 1;
                resetListAnswer();
                Future.delayed(Duration(milliseconds: 50), () {
                  randomBoxPosition();
                  getListAnswer();
                });
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
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      fit: StackFit.expand,
      children: [
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
