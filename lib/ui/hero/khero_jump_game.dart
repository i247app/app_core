import 'dart:async';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kimage_animation_helper.dart';
import 'package:app_core/helper/koverlay_helper.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/ui/hero/widget/khero_game_end.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/ui/hero/widget/khero_game_level.dart';
import 'package:app_core/header/kassets.dart';

class KHeroJumpGame extends StatefulWidget {
  final KHero? hero;

  const KHeroJumpGame({this.hero});

  @override
  _KHeroJumpGameState createState() => _KHeroJumpGameState();
}

class _KHeroJumpGameState extends State<KHeroJumpGame> {
  int? overlayID;
  int currentLevel = 0;
  List<String> levelBackground = [
    KAssets.MOON_LIGHT,
    KAssets.MOON_DARK,
    KAssets.GAME_BACKGROUND_LIGHT,
    KAssets.GAME_BACKGROUND_DARK,
  ];

  String gameBackground = Math.Random().nextDouble() >= 0.5
      ? KAssets.MOON_LIGHT
      : KAssets.MOON_DARK;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.showHeroGameEndOverlay(
    //       () {
    //     if (this.overlayID != null) {
    //       KOverlayHelper.removeOverlay(this.overlayID!);
    //       this.overlayID = null;
    //     }
    //   },
    // );
  }

  void showHeroGameEndOverlay(Function() onFinish) async {
    final heroGameEnd = KHeroGameEnd(
      hero: KHero()..imageURL = KImageAnimationHelper.randomImage,
      onFinish: onFinish,
    );
    showCustomOverlay(heroGameEnd);
  }

  void showHeroGameLevelOverlay(Function() onFinish) async {
    final heroGameLevel = KHeroGameLevel(
      onFinish: onFinish,
    );
    showCustomOverlay(heroGameLevel);
  }

  void showCustomOverlay(Widget view) {
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black.withOpacity(0.6)),
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
                  levelBackground[currentLevel],
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
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _KJumpGameScreen(
                      hero: widget.hero,
                      onFinishLevel: (level) {
                        if (level <= 3) {
                          this.showHeroGameLevelOverlay(
                            () {
                              if (this.overlayID != null) {
                                KOverlayHelper.removeOverlay(this.overlayID!);
                                this.overlayID = null;
                              }
                            },
                          );
                        }
                      },
                      onChangeLevel: (level) => this.setState(
                        () {
                          this.currentLevel = Math.Random().nextInt(4);
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

class _KJumpGameScreen extends StatefulWidget {
  final KHero? hero;
  final Function(int)? onChangeLevel;
  final Function? onFinishLevel;

  const _KJumpGameScreen({this.hero, this.onChangeLevel, this.onFinishLevel});

  @override
  _KJumpGameScreenState createState() => _KJumpGameScreenState();
}

class _KJumpGameScreenState extends State<_KJumpGameScreen>
    with TickerProviderStateMixin {
  late Animation<Offset> _bouncingAnimation;
  late Animation<double> _scaleAnimation, _moveUpAnimation, _heroScaleAnimation;
  late AnimationController _heroScaleAnimationController,
      _bouncingAnimationController,
      _scaleAnimationController,
      _moveUpAnimationController,
      _spinAnimationController;

  double screenWidth = 0;
  double screenHeight = 0;
  double heroY = 0;
  double initialPos = 0;
  double height = 0;
  double time = 0;
  double gravity = -6.0;
  double velocity = 3.5;
  Timer? _timer;
  bool isStart = false;
  double heroHeight = 80;
  double heroWidth = 80;
  int trueAnswer = 2;
  bool? result;
  bool isScroll = true;
  double scrollSpeed = 0.01;
  bool isShooting = false;
  int eggReceive = 0;
  bool isWrongAnswer = false;
  int rightAnswerCount = 0;
  int wrongAnswerCount = 0;
  int currentLevel = 0;
  bool canAdvance = false;
  List<double> levelHardness = [0.7, 0.8, 0.9, 1.0];
  List<String> levelIconAssets = [
    KAssets.BULLET_BALL_GREEN,
    KAssets.BULLET_BALL_BLUE,
    KAssets.BULLET_BALL_ORANGE,
    KAssets.BULLET_BALL_RED,
  ];

  int points = 0;
  bool resetPos = false;
  bool isShowPlusPoint = false;
  DateTime? lastGetPointTime;

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

  List<double> barrierX = [2, 2 + 1.5];
  List<String> barrierImageUrls = [
    KImageAnimationHelper.randomImage,
    KImageAnimationHelper.randomImage,
  ];

  int get getRandomAnswer => rightAnswers[currentQuestionIndex] <= 4
      ? (Math.Random().nextInt(4) + rightAnswers[currentQuestionIndex])
      : (Math.Random().nextInt(4) + rightAnswers[currentQuestionIndex] - 3);

  bool get canRestartGame =>
      currentLevel + 1 < levelHardness.length ||
      (currentLevel < levelHardness.length &&
          (rightAnswerCount / questions.length) < levelHardness[currentLevel]);

  List<int> barrierValues = [];
  double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.6, 0.4],
  ];

  @override
  void initState() {
    super.initState();

    barrierValues = [
      this.getRandomAnswer,
      this.getRandomAnswer,
    ];

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
            this.setState(() {
              isShowPlusPoint = false;
            });
            Future.delayed(Duration(milliseconds: 500), () {
              this._scaleAnimationController.reset();
              this._moveUpAnimationController.reset();
            });
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
      ..addStatusListener((status) {
        // if (mounted && status == AnimationStatus.completed) {
        //   Future.delayed(Duration(milliseconds: 500), () {
        //     this.setState(() {
        //       isShowPlusPoint = false;
        //     });
        //     Future.delayed(Duration(milliseconds: 500), () {
        //       this._scaleAnimationController.reset();
        //     });
        //   });
        // } else if (mounted && status == AnimationStatus.dismissed) {}
      });
    _moveUpAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _moveUpAnimationController, curve: Curves.bounceOut));

    // this.screenHeight = MediaQuery.of(context).size.height;
    // this.screenWidth = MediaQuery.of(context).size.width;

    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (isStart) {
        height = (gravity - points * 0.2) * time * time + velocity * time;
        final pos = initialPos - height;

        setState(() {
          if (pos <= -1.7) {
          } else if (pos <= 0) {
            heroY = pos;
          } else
            heroY = 0;
        });

        // if (isReachTarget() &&
        //     (lastGetPointTime == null ||
        //         lastGetPointTime!.difference(DateTime.now()).inMilliseconds <
        //             -1000)) {
        //   this._scaleAnimationController.reset();
        //   this.setState(() {
        //     isShowPlusPoint = true;
        //   });
        //   this._scaleAnimationController.forward();
        //   setState(() {
        //     // resetPos = true;
        //     lastGetPointTime = DateTime.now();
        //     points = points + 1;
        //   });
        // }
        if (isScroll) {
          checkResult();
        }

        time += 0.01;

        moveMap();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleAnimationController.dispose();
    _spinAnimationController.dispose();
    _moveUpAnimationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool isReachTarget() {
    return false;
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
        if (currentLevel < levelHardness.length) {
          speed += scrollSpeed * levelHardness[currentLevel];
        }
        setState(() {
          barrierX[i] -= scrollSpeed;
        });

        if (barrierX[i] <= -1.5) {
          setState(() {
            barrierX[i] += 3;
            // points += 1;
            barrierValues[i] = this.getRandomAnswer;
          });
        }
      }
    }
  }

  void checkResult() {
    if (isScroll) {
      for (int i = 0; i < barrierX.length; i++) {
        double _barrierWidth =
            (MediaQuery.of(context).size.width / 2) * barrierWidth / 2;
        double _barrierHeight =
            (MediaQuery.of(context).size.height / 2) * barrierHeight[i][1];

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
            (-0.7 * MediaQuery.of(context).size.height / 2) / 2 +
                (_barrierHeight / 2);
        double topBarrier =
            (-0.7 * MediaQuery.of(context).size.height / 2) / 2 -
                (_barrierHeight / 2);

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
          this.setState(() {
            spinningHeroIndex = i;
            isShooting = false;
          });
          bool isTrueAnswer =
              barrierValues[i] == rightAnswers[currentQuestionIndex];
          if (isTrueAnswer) {
            this.setState(() {
              isShowPlusPoint = true;
            });
            this._scaleAnimationController.reset();
            this._moveUpAnimationController.reset();
            this._scaleAnimationController.forward();
            this._moveUpAnimationController.forward();
            this.setState(() {
              result = true;
              points = points + 5;
              isScroll = false;
              if (!isWrongAnswer) {
                rightAnswerCount += 1;
              }
              isWrongAnswer = false;
            });

            Future.delayed(Duration(milliseconds: 1500), () {
              if (currentQuestionIndex + 1 < questions.length) {
                this.setState(() {
                  currentQuestionIndex = currentQuestionIndex + 1;
                  barrierX = [2, 2 + 1.5];
                  barrierImageUrls = [
                    KImageAnimationHelper.randomImage,
                    KImageAnimationHelper.randomImage
                  ];
                  barrierValues = [
                    this.getRandomAnswer,
                    this.getRandomAnswer,
                  ];
                });
                Future.delayed(Duration(milliseconds: 50), () {
                  isScroll = true;
                });
              } else {
                this.setState(() {
                  if (rightAnswerCount / questions.length >=
                      levelHardness[currentLevel]) {
                    eggReceive = eggReceive + 1;
                    if (currentLevel + 1 < levelHardness.length) {
                      canAdvance = true;
                      if (widget.onFinishLevel != null) {
                        widget.onFinishLevel!(currentLevel + 1);
                      }
                    }
                  }
                  isStart = false;
                  barrierX = [2, 2 + 1.5];
                  barrierImageUrls = [
                    KImageAnimationHelper.randomImage,
                    KImageAnimationHelper.randomImage
                  ];
                  barrierValues = [
                    this.getRandomAnswer,
                    this.getRandomAnswer,
                  ];
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
      }
    }
  }

  void start() {
    if (!isStart) {
      if (currentLevel == 0) {
        setState(() {
          isStart = true;
          time = 0;
        });
      } else {
        setState(() {
          isStart = true;
          time = 0;
        });
      }
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
      this.isStart = true;
      this.isScroll = true;
      this.isShooting = false;
      this.result = null;
      this.points = 0;
      this.currentQuestionIndex = 0;
      this.spinningHeroIndex = null;
      this.barrierX = [2, 2 + 1.5];
      this.barrierImageUrls = [
        KImageAnimationHelper.randomImage,
        KImageAnimationHelper.randomImage,
      ];
      isWrongAnswer = false;
      rightAnswerCount = 0;
      wrongAnswerCount = 0;
      canAdvance = false;
      this.barrierValues = [getRandomAnswer, getRandomAnswer];
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      fit: StackFit.expand,
      children: [
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
        if (!isStart)
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
                    Text(
                      "Tap To Start",
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
                        ? Text(
                            "Tap To Play Next Level",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )
                        : Text(
                            "Tap To Re-play Level",
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
        Container(
          width: heroWidth,
          height: heroHeight,
          alignment: Alignment(0, heroY + 1),
          child: widget.hero?.imageURL != null
              ? Image.network(
            widget.hero!.imageURL!,
            width: heroWidth,
            height: heroHeight,
            errorBuilder: (context, error, stack) =>
                Image.asset(
                  KAssets.IMG_TAMAGO_LIGHT_1,
                  width: heroWidth,
                  height: heroHeight,
                  package: 'app_core',
                ),
          )
              : Image.asset(
            KAssets.IMG_TAMAGO_LIGHT_1,
            width: heroWidth,
            height: heroHeight,
            package: 'app_core',
          ),
        ),
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
                          borderRadius: BorderRadius.circular(5),
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
                          levelIconAssets[currentLevel] != null)
                        Positioned(
                          left: -40,
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
        GestureDetector(
            onTap: isStart
                ? jump
                : (result == null
                    ? start
                    : (canRestartGame ? restartGame : () {}))),
        Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(0, 170),
            child: Transform.translate(
              offset: Offset(0, -80 * _moveUpAnimation.value),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: isShowPlusPoint ? 1 : 0,
                child: Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                  size: 50,
                ),
              ),
            ),
          ),
        ),
        // if (isStart && result != null)
        //   Align(
        //     alignment: Alignment(0, -0.6),
        //     child: Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 10),
        //       child: Text(
        //         result! ? "Right answer!" : "Wrong answer",
        //         style: TextStyle(
        //           fontSize: 30,
        //           color: result! ? Colors.green : Colors.red,
        //         ),
        //       ),
        //     ),
        //   ),
        // if (isStart || result != null)
        //   Align(
        //     alignment: Alignment.topRight,
        //     child: Container(
        //       width: 80,
        //       height: 80,
        //       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage(Assets.IMG_TARGET_ORANGE),
        //           fit: BoxFit.contain,
        //         ),
        //       ),
        //       child: Text(
        //         "${this.rightAnswerCount}",
        //         textScaleFactor: 1.0,
        //         textAlign: TextAlign.center,
        //         style: Theme.of(context).textTheme.bodyText1!.copyWith(
        //               color: Colors.white,
        //               fontSize: 35,
        //               fontWeight: FontWeight.bold,
        //             ),
        //       ),
        //     ),
        //   ),
        // if (isStart || result != null)
        //   Align(
        //     alignment: Alignment.bottomRight,
        //     child: Container(
        //       width: 80,
        //       height: 80,
        //       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage(Assets.TARGET_ORANGE),
        //           fit: BoxFit.contain,
        //         ),
        //       ),
        //       child: Text(
        //         "${this.points}",
        //         textAlign: TextAlign.center,
        //         style: Theme.of(context).textTheme.bodyText1!.copyWith(
        //               fontSize: 35,
        //               fontWeight: FontWeight.bold,
        //             ),
        //       ),
        //     ),
        //   ),
        if (isStart) ...[
          Align(
            alignment: Alignment.topCenter,
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
                      value: barrierValues[i],
                      rotateAngle: spinningHeroIndex == i
                          ? -this._spinAnimationController.value * 4 * Math.pi
                          : 0,
                      bouncingAnimation: spinningHeroIndex == i
                          ? _bouncingAnimation.value
                          : Offset(0, 0),
                      scaleAnimation:
                          spinningHeroIndex == i ? _heroScaleAnimation : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
  final int value;
  final Offset bouncingAnimation;

  _Barrier({
    required this.barrierHeight,
    required this.barrierWidth,
    required this.barrierX,
    required this.imageUrl,
    required this.rotateAngle,
    this.scaleAnimation,
    required this.value,
    required this.bouncingAnimation,
  });

  @override
  Widget build(context) {
    return Container(
      alignment:
          Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth), 0.3),
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) * barrierWidth,
        height: (MediaQuery.of(context).size.height / 2) * barrierHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: (MediaQuery.of(context).size.width / 2) * barrierWidth,
              height: (MediaQuery.of(context).size.height / 2) *
                  barrierHeight *
                  0.4,
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
            Transform.translate(
              offset: bouncingAnimation,
              child: Transform.rotate(
                angle: rotateAngle,
                child: scaleAnimation != null
                    ? (ScaleTransition(
                        scale: scaleAnimation!,
                        child: Image.network(
                          imageUrl,
                          width: (MediaQuery.of(context).size.width / 2) *
                              barrierWidth,
                          height: (MediaQuery.of(context).size.height / 2) *
                              barrierHeight *
                              0.6,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => Image.asset(
                            KAssets.IMG_TAMAGO_LIGHT_1,
                            width: (MediaQuery.of(context).size.width / 2) *
                                barrierWidth,
                            height: (MediaQuery.of(context).size.height / 2) *
                                barrierHeight *
                                0.6,
                            package: 'app_core',
                          ),
                        ),
                      ))
                    : (Image.network(
                        imageUrl,
                        width: (MediaQuery.of(context).size.width / 2) *
                            barrierWidth,
                        height: (MediaQuery.of(context).size.height / 2) *
                            barrierHeight *
                            0.6,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Image.asset(
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
      ),
    );
  }
}
