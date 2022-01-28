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
import 'package:app_core/ui/game/service/kgame_controller.dart';
import 'package:app_core/ui/game/service/kgame_data.dart';
import 'package:app_core/ui/hero/widget/kegg_hero_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_count_down_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_end.dart';
import 'package:app_core/ui/hero/widget/khero_game_highscore_dialog.dart';
import 'package:app_core/ui/hero/widget/khero_game_pause_dialog.dart';
import 'package:app_core/ui/hero/widget/ktamago_chan_jumping.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class KGameJumpUp extends StatefulWidget {
  static const GAME_ID = "530";
  static const GAME_NAME = "jump_up";

  final KGameController controller;
  final KHero? hero;
  final Function? onFinishLevel;

  const KGameJumpUp({
    Key? key,
    this.hero,
    this.onFinishLevel,
    required this.controller,
  }) : super(key: key);

  @override
  _KGameJumpUpState createState() => _KGameJumpUpState();
}

class _KGameJumpUpState extends State<KGameJumpUp>
    with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  String? correctAudioFileUri;
  String? wrongAudioFileUri;

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

  KGameData get gameData => widget.controller.value;

  double heroY = 0;
  double initialPos = 0;
  double height = 0;
  double time = 0;
  double gravity = -8.0;
  bool isShowCountDown = false;
  double velocity = 2.0;
  Timer? _timer;
  double heroHeight = 90;
  double heroWidth = 90;
  bool isScroll = true;
  double scrollSpeed = 0.01;
  bool isWrongAnswer = false;
  int? spinningHeroIndex;
  int? currentShowStarIndex;
  int? currentCollisionIndex;
  bool isPlaySound = false;
  List<double> barrierX = [2, 2 + 1.5];
  List<String> barrierImageUrls = [
    KImageAnimationHelper.randomImage,
    KImageAnimationHelper.randomImage,
  ];
  List<KAnswer> barrierValues = [];
  double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.6, 0.4],
  ];
  double topBoundary = -2.1;

  bool get isStart => gameData.isStart ?? false;

  bool get isPause => gameData.isPause ?? false;

  bool get canAdvance => gameData.canAdvance ?? false;

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

    barrierValues = [];
    barrierValues.add(this.getRandomAnswer());
    barrierValues.add(this.getRandomAnswer());

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
              Future.delayed(Duration(milliseconds: 500), () {
                if (mounted) {
                  this._scaleAnimationController.reset();
                  this._moveUpAnimationController.reset();
                }
              });
            }
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
      ..addStatusListener((status) {});
    _moveUpAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _moveUpAnimationController, curve: Curves.bounceOut));

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
  void dispose() {
    _timer?.cancel();
    _heroScaleAnimationController.dispose();
    _playerScaleAnimationController.dispose();
    _bouncingAnimationController.dispose();
    _scaleAnimationController.dispose();
    _moveUpAnimationController.dispose();
    _spinAnimationController.dispose();
    _playerSpinAnimationController.dispose();

    audioPlayer.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  KAnswer getRandomAnswer() {
    if (currentQuestionAnswers.length <= 0) {
      return KAnswer();
    }

    final List<KAnswer> answerNotInCurrent = currentQuestionAnswers
        .where((answer) =>
            barrierValues
                .map((barrierValue) => barrierValue.text)
                .toList()
                .indexOf(answer.text) ==
            -1)
        .toList();

    if (answerNotInCurrent.length > 0) {
      return answerNotInCurrent[
          Math.Random().nextInt(answerNotInCurrent.length)];
    } else {
      return currentQuestionAnswers[
          Math.Random().nextInt(currentQuestionAnswers.length)];
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

  void jump() {
    setState(() {
      if (isStart) {
        time = 0;
        initialPos = heroY;
      }
    });
  }

  void moveMap() {
    if (isScroll) {
      for (int i = 0; i < barrierX.length; i++) {
        double speed = scrollSpeed;
        if (currentLevel < levelCount) {
          speed += scrollSpeed * levelHardness[currentLevel];
        }
        setState(() {
          barrierX[i] -= scrollSpeed;
        });

        if (barrierX[i] <= -1.5) {
          setState(() {
            barrierX[i] += 3;
            barrierValues[i] = this.getRandomAnswer();
            barrierImageUrls[i] = KImageAnimationHelper.randomImage;
          });
        }
      }
    }
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

  void checkResult() {
    if (isScroll) {
      for (int i = 0; i < barrierX.length; i++) {
        double _barrierWidth =
            (MediaQuery.of(context).size.width / 2) * barrierWidth / 2 - 10;
        double _barrierHeight = (MediaQuery.of(context).size.height / 2) *
            barrierHeight[i][1] *
            0.35;

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
            (-1.0 * MediaQuery.of(context).size.height / 2) / 2;
        double topBarrier =
            (-1.0 * MediaQuery.of(context).size.height / 2) / 2 -
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
          bool isTrueAnswer = barrierValues[i].isCorrect ?? false;

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
            });
            this._scaleAnimationController.reset();
            this._scaleAnimationController.forward();

            widget.controller.value.result = true;
            widget.controller.value.point = point + 5;
            if (!isWrongAnswer) {
              this.setState(() {
                currentShowStarIndex = i;
              });
              widget.controller.value.rightAnswerCount = rightAnswerCount + 1;
              this._moveUpAnimationController.reset();
              this._moveUpAnimationController.forward();
            }
            this.setState(() {
              isScroll = false;
              isWrongAnswer = false;
            });

            Future.delayed(Duration(milliseconds: 1500), () {
              if (mounted && currentQuestionIndex + 1 < questions.length) {
                widget.controller.value.currentQuestionIndex =
                    currentQuestionIndex + 1;
                this.setState(() {
                  barrierX = [2, 2 + 1.5];
                  barrierImageUrls = [
                    KImageAnimationHelper.randomImage,
                    KImageAnimationHelper.randomImage
                  ];
                  barrierValues = [];
                  barrierValues.add(this.getRandomAnswer());
                  barrierValues.add(this.getRandomAnswer());
                  this.currentCollisionIndex = null;
                  this.isPlaySound = false;
                });
                Future.delayed(Duration(milliseconds: 50), () {
                  // this.setState(() {
                  //   currentQuestionAnswers = questionAnswers;
                  // });
                  this.setState(() {
                    barrierValues = [];
                    barrierValues.add(this.getRandomAnswer());
                    barrierValues.add(this.getRandomAnswer());
                    isScroll = true;
                  });
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

                this.setState(() {
                  barrierX = [2, 2 + 1.5];
                  barrierImageUrls = [
                    KImageAnimationHelper.randomImage,
                    KImageAnimationHelper.randomImage
                  ];
                  barrierValues = [];
                  barrierValues.add(this.getRandomAnswer());
                  barrierValues.add(this.getRandomAnswer());
                  this.currentCollisionIndex = null;
                  this.isPlaySound = false;
                });

                if (widget.onFinishLevel != null) {
                  widget.onFinishLevel!();
                }
              }
            });
          } else {
            _playerScaleAnimationController.forward();
            widget.controller.value.result = false;
            widget.controller.value.point = point > 0 ? point - 1 : 0;
            if (!isWrongAnswer) {
              widget.controller.value.wrongAnswerCount = wrongAnswerCount + 1;
              this.setState(() {
                isWrongAnswer = true;
              });
            }
          }
          widget.controller.notify();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      fit: StackFit.expand,
      children: [
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
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[i][1],
                    imageUrl: barrierImageUrls[i],
                    answer: barrierValues[i],
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
        GestureDetector(
          onTap: (isStart && !isPause) ? jump : () {},
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
  final String imageUrl;
  final double rotateAngle;
  final Animation<double>? scaleAnimation;
  final KAnswer answer;
  final Offset bouncingAnimation;
  final double? starY;
  final bool? isShowStar;

  _Barrier({
    required this.barrierHeight,
    required this.barrierWidth,
    required this.barrierX,
    required this.imageUrl,
    required this.rotateAngle,
    this.scaleAnimation,
    required this.answer,
    required this.bouncingAnimation,
    this.starY,
    this.isShowStar,
  });

  @override
  Widget build(context) {
    return Container(
      alignment:
          Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth), -0.3),
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
                      "${answer.text}",
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
