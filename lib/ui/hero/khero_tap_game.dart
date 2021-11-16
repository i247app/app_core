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

  int currentLevel = 0;

  void showHeroGameEndOverlay(Function() onFinish) async {
    final heroGameEnd = KHeroGameEnd(
      hero: KHero()..imageURL = KImageAnimationHelper.randomImage,
      onFinish: onFinish,
    );
    showCustomOverlay(heroGameEnd);
  }

  void showHeroGameLevelOverlay(Function() onFinish) async {
    final heroGameLevel = KHeroGameLevel(onFinish: onFinish);
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
                    child: _KTapGameScreen(
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

class _KTapGameScreen extends StatefulWidget {
  final KHero? hero;
  final Function(int)? onChangeLevel;
  final Function? onFinishLevel;

  const _KTapGameScreen({this.hero, this.onChangeLevel, this.onFinishLevel});

  @override
  _KTapGameScreenState createState() => _KTapGameScreenState();
}

class _KTapGameScreenState extends State<_KTapGameScreen>
    with TickerProviderStateMixin {
  late Animation<Offset> _bouncingAnimation;
  late Animation<double> _playerScaleAnimation,
      _scaleAnimation,
      _moveUpAnimation,
      _heroScaleAnimation;
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
  double gravity = -8.0;
  double velocity = 2.0;
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
  List<int> levelPlayTimes = [0, 0, 0, 0];
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
  int? currentShowStarIndex;

  List<double> barrierX = [0, 0, 0, 0];
  List<double> barrierY = [0, 0, 0, 0];

  Math.Random rand = new Math.Random();

  int get getRandomAnswer => rightAnswers[currentQuestionIndex] <= 4
      ? (rand.nextInt(4) + rightAnswers[currentQuestionIndex])
      : (rand.nextInt(4) + rightAnswers[currentQuestionIndex] - 3);

  bool get canRestartGame =>
      currentLevel + 1 < levelHardness.length ||
      (currentLevel < levelHardness.length &&
          (rightAnswerCount / questions.length) < levelHardness[currentLevel]);

  List<int> barrierValues = [];
  double topBoundary = -2.1;

  @override
  void initState() {
    super.initState();

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

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 1000), () {
            this.setState(() {
              currentShowStarIndex = null;
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
      ..addStatusListener((status) {});
    _moveUpAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _moveUpAnimationController, curve: Curves.bounceOut));

    // this.screenHeight = MediaQuery.of(context).size.height;
    // this.screenWidth = MediaQuery.of(context).size.width;

    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (isStart) {
        if (currentLevel < 4) {
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
    _scaleAnimationController.dispose();
    _moveUpAnimationController.dispose();
    _spinAnimationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void getListAnswer() {
    final currentRightAnswer = rightAnswers[currentQuestionIndex];

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

  void handlePickAnswer(int answer, int answerIndex) {
    bool isTrueAnswer = answer == rightAnswers[currentQuestionIndex];

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
          // this._moveUpAnimationController.reset();
          // this._moveUpAnimationController.forward();
        }
        isWrongAnswer = false;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        if (currentQuestionIndex + 1 < questions.length) {
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
              if (currentLevel + 1 < levelHardness.length) {
                canAdvance = true;
                if (widget.onFinishLevel != null) {
                  widget.onFinishLevel!(currentLevel + 1);
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
        if (isStart)
          Align(
            alignment: Alignment(-1, -1),
            child: currentLevel < 4
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
                            KUtil.prettyStopwatch(
                              Duration(seconds: levelPlayTimes[currentLevel]),
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
        if (!isStart)
          GestureDetector(
              onTap: result == null
                  ? start
                  : (canRestartGame ? restartGame : () {})),
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
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              child: Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              onTap: () => Navigator.of(context).pop(),
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
