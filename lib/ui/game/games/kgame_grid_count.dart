import 'dart:async';
import 'dart:convert';
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
import 'package:app_core/ui/widget/kflip_card/kflip_card.dart';
import 'package:app_core/ui/widget/kflip_card/kflip_card_controller.dart';

class KGameGridCount extends StatefulWidget {
  static const GAME_ID = "517";
  static const GAME_NAME = "grid_count";

  final KGameController controller;
  final KHero? hero;
  final Function? onFinishLevel;

  const KGameGridCount({
    Key? key,
    this.hero,
    this.onFinishLevel,
    required this.controller,
  }) : super(key: key);

  @override
  _KGameGridCountState createState() => _KGameGridCountState();
}

class _KGameGridCountState extends State<KGameGridCount>
    with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  String? correctAudioFileUri;
  String? wrongAudioFileUri;

  late Animation<Color?> _correctBlinkingAnimation, _incorrectBlinkingAnimation;
  late Animation<Offset> _bouncingAnimation;
  late Animation<double> _moveUpAnimation, _heroScaleAnimation;

  late AnimationController _heroScaleAnimationController,
      _bouncingAnimationController,
      _moveUpAnimationController,
      _spinAnimationController,
      _correctBlinkingAnimationController,
      _incorrectBlinkingAnimationController;
  List<KFlipCardController> _flipCardControllers = [];

  KGameData get gameData => widget.controller.value;

  bool isWrongAnswer = false;
  int? spinningHeroIndex;
  int? currentShowStarIndex;
  int? correctAnswerIndex;
  int? incorrectAnswerIndex;
  bool isAnswering = false;
  bool isPlaySound = false;
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

  List<String> correctOrderAnswers = [];
  List<String> answers = [];
  List<String> hiddenAnswers = [];
  List<String> displayAnswers = [];
  List<String> tmpDisplayAnswers = [];

  // int hardShuffleLevel = 3;
  // int hardLevel = 2;
  int hardShuffleLevel = 1;
  int hardLevel = 1;
  int shuffleLevel = 1;

  @override
  void initState() {
    super.initState();

    loadAudioAsset();

    _correctBlinkingAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150))
          ..addListener(() => setState(() {}));
    _correctBlinkingAnimation =
        ColorTween(begin: Colors.green, end: Colors.orange).animate(
            CurvedAnimation(
                parent: _correctBlinkingAnimationController,
                curve: Curves.bounceInOut));
    _correctBlinkingAnimationController.addStatusListener((status) {
      if (mounted) {
        if (status == AnimationStatus.completed) {
          _correctBlinkingAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _correctBlinkingAnimationController.forward();
        }
      }
    });

    _incorrectBlinkingAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150))
          ..addListener(() => setState(() {}));
    _incorrectBlinkingAnimation =
        ColorTween(begin: Colors.red, end: Colors.orange).animate(
            CurvedAnimation(
                parent: _incorrectBlinkingAnimationController,
                curve: Curves.bounceInOut));
    _incorrectBlinkingAnimationController.addStatusListener((status) {
      if (mounted) {
        if (status == AnimationStatus.completed) {
          _incorrectBlinkingAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _incorrectBlinkingAnimationController.forward();
        }
      }
    });

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

    getAnswers();
  }

  @override
  void dispose() {
    _heroScaleAnimationController.dispose();
    _bouncingAnimationController.dispose();
    _moveUpAnimationController.dispose();
    _spinAnimationController.dispose();
    _incorrectBlinkingAnimationController.dispose();
    _correctBlinkingAnimationController.dispose();

    audioPlayer.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  void getAnswers() {
    int startNumber = 1;
    int endNumber = 9;

    this.setState(() {
      for (int i = startNumber; i <= endNumber; i++) {
        correctOrderAnswers.add(i.toString());
        _flipCardControllers.add(KFlipCardController());
      }
    });

    print(
        "widget.controller.value.currentLevel ${startNumber} ${endNumber} ${correctOrderAnswers}");
    this.randomBoxPosition();
    this.displayQuestion(isStartup: true);
  }

  void displayQuestion({bool isStartup = false}) async {
    if ((widget.controller.value.currentLevel ?? 0) >= hardLevel) {
      int currentAnswerIndex = displayAnswers.length;
      int totalDisplayAnswer = 3;
      if (this.barrierValues.length - this.displayAnswers.length <=
          totalDisplayAnswer) {
        totalDisplayAnswer =
            this.barrierValues.length - this.displayAnswers.length;
      }
      await closeTempDisplayAnswers();
      this.setState(() {
        this.tmpDisplayAnswers = [];
        if (totalDisplayAnswer > 0) {
          for (int i = 0; i < totalDisplayAnswer; i++) {
            if (i == 0) {
              this
                  .tmpDisplayAnswers
                  .add(correctOrderAnswers[currentAnswerIndex]);
            } else {
              final barrierValuesFiltered =
                  this.barrierValues.where((barrierValue) {
                return !this.displayAnswers.contains(barrierValue.text!) &&
                    !this.tmpDisplayAnswers.contains(barrierValue.text!);
              }).toList();
              final answer = barrierValuesFiltered[
                  Math.Random().nextInt(barrierValuesFiltered.length)];
              this.tmpDisplayAnswers.add(answer.text!);
            }
          }
        }
      });
      if (!isStartup &&
          (widget.controller.value.currentLevel ?? 0) >= hardShuffleLevel) {
        this.randomBoxPosition();
      }
      await openTempDisplayAnswers();
    }
  }

  Future<void> closeTempDisplayAnswers() async {
    List<Future> futures = [];
    final tempDisplayAnswersToClose = tmpDisplayAnswers
        .where((answer) => displayAnswers.indexOf(answer) == -1)
        .toList();

    for (int i = 0; i < tempDisplayAnswersToClose.length; i++) {
      int answerIndex = barrierValues.indexWhere(
          (barrierValue) => barrierValue.text == tempDisplayAnswersToClose[i]);
      if (answerIndex > -1) {
        futures.add(
            _flipCardControllers[answerIndex].flip(targetSide: KCardSide.back));
      }
    }
    await Future.wait(futures);
  }

  Future<void> openTempDisplayAnswers() async {
    List<Future> futures = [];
    for (int i = 0; i < tmpDisplayAnswers.length; i++) {
      int answerIndex = barrierValues.indexWhere(
          (barrierValue) => barrierValue.text == tmpDisplayAnswers[i]);
      if (answerIndex > -1) {
        futures.add(_flipCardControllers[answerIndex]
            .flip(targetSide: KCardSide.front));
      }
    }
    await Future.wait(futures);
  }

  void randomBoxPosition() {
    Math.Random rand = new Math.Random();
    this.setState(() {
      if (barrierValues.length == 0) {
        barrierValues =
            correctOrderAnswers.map((e) => KAnswer()..text = e).toList();
        if ((widget.controller.value.currentLevel ?? 0) >= shuffleLevel) {
          barrierValues.shuffle();
          while (jsonEncode(barrierValues.map((e) => e.text).toList()) ==
                  jsonEncode(correctOrderAnswers) ||
              jsonEncode(barrierValues
                      .map((e) => e.text)
                      .toList()
                      .reversed
                      .toList()) ==
                  jsonEncode(correctOrderAnswers)) {
            barrierValues.shuffle();
          }
        }
      } else {
        List<String> _pickedAnswers = [
          ...answers,
        ];
        for (int i = 0; i < barrierValues.length; i++) {
          final barrierValue = barrierValues[i];
          print("_answersFiltered ${_pickedAnswers}");
          if (!answers.contains(barrierValue.text!)) {
            final _answersFiltered = correctOrderAnswers
                .where((answer) => !_pickedAnswers.contains(answer))
                .toList();
            print("_answersFiltered ${_answersFiltered}");
            String _textAnswer =
                _answersFiltered[rand.nextInt(_answersFiltered.length)];
            if (_answersFiltered.length > 1) {
              while (barrierValue.text == _textAnswer) {
                _textAnswer =
                    _answersFiltered[rand.nextInt(_answersFiltered.length)];
              }
            }
            barrierValues[i].text = _textAnswer;
            _pickedAnswers.add(_textAnswer);
          }
        }
      }
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
          await audioPlayer.play(DeviceFileSource(correctAudioFileUri ?? ""), mode: PlayerMode.lowLatency);
        } else {
          await audioPlayer.play(DeviceFileSource(wrongAudioFileUri ?? ""), mode: PlayerMode.lowLatency);
        }
      } catch (e) {}
    }
    this.setState(() {
      this.isPlaySound = false;
    });
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
      spinningHeroIndex = answerIndex;
    });
    this._spinAnimationController.reset();
    this._spinAnimationController.forward();

    if (isTrueAnswer) {
      this.setState(() {
        this.displayAnswers.add(answer.text!);
      });
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
        correctAnswerIndex = answerIndex;
      });

      this._correctBlinkingAnimationController.reset();
      this._correctBlinkingAnimationController.forward();

      this.setState(() {
        answers.add(answer.text!);
      });

      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          this.displayQuestion();
          this.setState(() {
            spinningHeroIndex = null;
            currentShowStarIndex = null;
            correctAnswerIndex = null;
          });
          this._correctBlinkingAnimationController.reset();
          Future.delayed(Duration(milliseconds: 50), () {
            if (mounted) {
              this._moveUpAnimationController.reset();

              if (answers.length == correctOrderAnswers.length) {
                if (currentLevel == eggReceive)
                  widget.controller.value.eggReceive = eggReceive + 1;
                widget.controller.value.canAdvance = true;

                widget.controller.value.isStart = false;
                widget.controller.notify();

                if (widget.onFinishLevel != null) {
                  widget.onFinishLevel!();
                }
              }

              this.setState(() {
                isAnswering = false;
                hiddenAnswers.add(answer.text!);
              });
            }
          });
        }
      });
    } else {
      this.setState(() {
        incorrectAnswerIndex = answerIndex;
      });
      this._incorrectBlinkingAnimationController.reset();
      this._incorrectBlinkingAnimationController.forward();
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

          Future.delayed(Duration(milliseconds: 250), () {
            if (mounted) {
              this.setState(() {
                spinningHeroIndex = null;
                incorrectAnswerIndex = null;
              });
              this._incorrectBlinkingAnimationController.reset();
            }
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
        if (barrierValues.length > 0)
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: GridView.count(
                childAspectRatio: MediaQuery.sizeOf(context).width /
                    (MediaQuery.sizeOf(context).height / 1.5),
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: List.generate(
                  barrierValues.length,
                  (i) => _Barrier(
                    onTap: (KAnswer answer) => handlePickAnswer(answer, i),
                    answer: barrierValues[i],
                    flipCardController: _flipCardControllers[i],
                    flipCardSide:
                        (widget.controller.value.currentLevel ?? 0) >= hardLevel
                            ? (tmpDisplayAnswers.contains(barrierValues[i].text)
                                ? KCardSide.front
                                : KCardSide.back)
                            : KCardSide.front,
                    rotateAngle: spinningHeroIndex == i
                        ? -this._spinAnimationController.value * 4 * Math.pi
                        : 0,
                    bouncingAnimation: spinningHeroIndex == i
                        ? _bouncingAnimation.value
                        : Offset(0, 0),
                    scaleAnimation:
                        spinningHeroIndex == i ? _heroScaleAnimation : null,
                    colorAnimation: correctAnswerIndex == i
                        ? _correctBlinkingAnimation.value
                        : (incorrectAnswerIndex == i
                            ? _incorrectBlinkingAnimation.value
                            : null),
                    starY: _moveUpAnimation.value,
                    isShowStar: currentShowStarIndex == i,
                    isCorrect:
                        hiddenAnswers.indexOf(barrierValues[i].text ?? "") > -1,
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

class _Barrier extends StatelessWidget {
  final double rotateAngle;
  final Animation<double>? scaleAnimation;
  final KAnswer answer;
  final Offset bouncingAnimation;
  final double? starY;
  final bool? isShowStar;
  final bool? isCorrect;
  final Color? colorAnimation;
  final Function(KAnswer value) onTap;
  final KFlipCardController? flipCardController;
  final KCardSide? flipCardSide;

  _Barrier({
    required this.rotateAngle,
    this.scaleAnimation,
    required this.answer,
    required this.bouncingAnimation,
    this.starY,
    this.isShowStar,
    this.isCorrect,
    required this.onTap,
    this.colorAnimation,
    this.flipCardController,
    this.flipCardSide,
  });

  @override
  Widget build(context) {
    final box = Container(
      width: 80,
      height: 80,
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
    );

    return InkWell(
      onTap: (isCorrect ?? false) || flipCardSide == KCardSide.back
          ? null
          : () {
              onTap(answer);
            },
      child: KFlipCard(
        flipOnTouch: false,
        controller: flipCardController,
        fill: KFill.back,
        direction: Axis.horizontal,
        initialSide: flipCardSide ?? KCardSide.front,
        front: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: (isCorrect ?? false)
                ? Colors.green
                : (colorAnimation ?? Colors.orange),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
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
                            duration: Duration(milliseconds: 250),
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
            ],
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: (isCorrect ?? false)
                ? Colors.green
                : (colorAnimation ?? Colors.orange),
          ),
        ),
      ),
    );
  }
}
