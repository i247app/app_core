import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:typed_data';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/koverlay_helper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/header/kassets.dart';
import 'package:path_provider/path_provider.dart';

class KHeroTapIntro extends StatefulWidget {
  final Function(int)? onChangeLevel;
  final Function? onFinishLevel;
  final bool isShowEndLevel;
  final bool isMuted;

  const KHeroTapIntro({
    this.onChangeLevel,
    this.onFinishLevel,
    required this.isShowEndLevel,
    required this.isMuted,
  });

  @override
  _KHeroTapIntroState createState() => _KHeroTapIntroState();
}

class _KHeroTapIntroState extends State<KHeroTapIntro>
    with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
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

  List<String> questions = [
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
  ];
  List<int> rightAnswers = [
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
  ];
  int currentQuestionIndex = 0;
  int? spinningHeroIndex;
  int? currentShowStarIndex;
  bool isPlaySound = false;

  List<double> barrierX = [0, 0, 0, 0];
  List<double> barrierY = [0, 0, 0, 0];

  Math.Random rand = new Math.Random();

  List<int> get listAnswers => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
      .where((item) => item != rightAnswers[currentQuestionIndex])
      .toList();

  int get getRandomAnswer => listAnswers[rand.nextInt(listAnswers.length)];

  List<int> barrierValues = [];
  double topBoundary = -2.1;

  int? overlayID;
  bool isPause = false;
  bool isBackgroundSoundPlaying = false;

  int tamagoJumpTimes =  5;

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
                guestAnswer();
              }
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

    this._shakeTheTopRightAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          this._shakeTheTopRightAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          this.handlePickAnswer(barrierValues[1], 1);
        }
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
        } else if (status == AnimationStatus.dismissed) {
          this.handlePickAnswer(barrierValues[0], 0);
        }
      });
    this._shakeTheTopLeftAnimation = Tween<double>(
      begin: 0,
      end: -0.1,
    ).animate(_shakeTheTopLeftAnimationController);

    getListAnswer();

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        startAnswer();
      }
    });
  }

  @override
  void dispose() {
    _heroScaleAnimationController.dispose();
    _bouncingAnimationController.dispose();
    _moveUpAnimationController.dispose();
    _spinAnimationController.dispose();
    _shakeTheTopLeftAnimationController.dispose();
    _shakeTheTopRightAnimationController.dispose();

    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }

    audioPlayer.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  void startAnswer() {
    this._bouncingAnimationController.forward();
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

    if (!widget.isMuted && !isPlaySound) {
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
        currentShowStarIndex = answerIndex;
        if (!_moveUpAnimationController.isAnimating) {
          this._moveUpAnimationController.reset();
          this._moveUpAnimationController.forward();
        }
      });
    }

    Future.delayed(Duration(milliseconds: 1000), () {
      if (mounted && currentQuestionIndex + 1 < questions.length) {
        this.setState(() {
          currentShowStarIndex = null;
          spinningHeroIndex = null;
          currentQuestionIndex = currentQuestionIndex + 1;
          getListAnswer();
        });

        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            startAnswer();
          }
        });
      } else {
        restartGame();
      }
    });
  }

  void restartGame() {
    this.setState(() {
      this.isPlaySound = false;
      this.currentQuestionIndex = 0;
      this.currentShowStarIndex = null;
      this.spinningHeroIndex = null;
      getListAnswer();
    });

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        startAnswer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            transform:
                Matrix4.rotationZ(_shakeTheTopRightAnimation.value * Math.pi),
            transformAlignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.35,
            child: Container(
              transform: Matrix4.rotationZ(
                  _shakeTheTopLeftAnimation.value * Math.pi),
              transformAlignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
              child: Transform.translate(
                offset: currentShowStarIndex == null ? _bouncingAnimation.value : Offset(0, 0),
                child: Image.asset(
                  KAssets.IMG_TAMAGO_CHAN,
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                  package: 'app_core',
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
                    value: barrierValues[i],
                    barrierY: i == 0 ? -1 : 1,
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
          alignment: Alignment(0, -0.5),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                questions[currentQuestionIndex],
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
  final bool? isShowStar;

  _Barrier({
    required this.rotateAngle,
    this.scaleAnimation,
    required this.barrierY,
    required this.value,
    required this.bouncingAnimation,
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
    );
  }
}