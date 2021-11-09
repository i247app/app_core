import 'dart:async';

import 'package:app_core/model/khero.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/header/kassets.dart';

class KHeroTraining extends StatefulWidget {
  final KHero? hero;

  const KHeroTraining({this.hero});

  @override
  _KHeroTrainingState createState() => _KHeroTrainingState();
}

class _KHeroTrainingState extends State<KHeroTraining>
    with TickerProviderStateMixin {
  late Animation<double> _scaleAnimation;
  late AnimationController _scaleAnimationController;

  double heroY = 0;
  double initialPos = 0;
  double height = 0;
  double time = 0;
  double gravity = -10.0;
  double velocity = 3.5;
  Timer? _timer;
  bool isStart = false;

  int points = 0;
  bool resetPos = false;
  double currentTarget = -1.3;
  double topTarget = -1.4;
  double bottomTarget = -0.7;
  bool isShowPlusPoint = false;
  DateTime? lastGetPointTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          this.setState(() {
            isShowPlusPoint = false;
          });
          Future.delayed(Duration(milliseconds: 500), () {
            this._scaleAnimationController.reset();
          });
        } else if (mounted && status == AnimationStatus.dismissed) {}
      });
    _scaleAnimation = new Tween(
      begin: 1.0,
      end: 2.0,
    ).animate(new CurvedAnimation(
        parent: _scaleAnimationController, curve: Curves.bounceOut));

    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (isStart) {
        height = (gravity - points * 0.2) * time * time + velocity * time;
        final pos = initialPos - height;

        setState(() {
          if (pos <= -2.4) {
          } else if (pos <= 0) {
            heroY = pos;
          } else
            heroY = 0;
        });

        if (isReachTarget() &&
            (lastGetPointTime == null ||
                lastGetPointTime!.difference(DateTime.now()).inMilliseconds <
                    -1000)) {
          this._scaleAnimationController.reset();
          this.setState(() {
            isShowPlusPoint = true;
          });
          this._scaleAnimationController.forward();
          setState(() {
            // resetPos = true;
            lastGetPointTime = DateTime.now();
            points = points + 1;
          });
        }

        // if (heroY == 0 && resetPos) {
        //   setState(() {
        //     resetPos = false;
        //   });
        // }

        time += 0.01;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleAnimationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool isReachTarget() {
    double topTargetValue =
        -this.topTarget * MediaQuery.of(context).size.height;
    double bottomTargetValue =
        -this.bottomTarget * MediaQuery.of(context).size.height;
    double heroPosValue = -heroY * MediaQuery.of(context).size.height;

    return heroPosValue >= bottomTargetValue + 128 &&
        heroPosValue <= topTargetValue;
  }

  void jump() {
    setState(() {
      if (!isStart) {
        isStart = true;
      }
      time = 0;
      initialPos = heroY;
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Transform.translate(
                      offset: Offset(0, 80),
                      child: Transform.translate(
                        offset: Offset(0, -80 * (_scaleAnimation.value - 1)),
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
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 80,
                      height: 80,
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            KAssets.IMG_TARGET_ORANGE,
                            package: 'app_core',
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: Text(
                        "${this.points}",
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 1 + topTarget),
                    child: Container(
                      width: ((bottomTarget - topTarget) / 2) *
                          MediaQuery.of(context).size.height,
                      height: ((bottomTarget - topTarget) / 2) *
                          MediaQuery.of(context).size.height,
                      color: Theme.of(context).backgroundColor,
                      child: Transform.scale(
                        scale: 1.0,
                        child: Image.asset(
                          isReachTarget()
                              ? KAssets.IMG_TARGET_GOLD
                              : KAssets.IMG_TARGET_GREEN,
                          width: ((bottomTarget - topTarget) / 2) *
                              MediaQuery.of(context).size.height,
                          height: ((bottomTarget - topTarget) / 2) *
                              MediaQuery.of(context).size.height,
                          package: 'app_core',
                        ),
                      ),
                    ),
                    // child: SizedBox(
                    //   width: ((bottomTarget - topTarget) / 2) *
                    //       MediaQuery.of(context).size.height,
                    //   height: ((bottomTarget - topTarget) / 2) *
                    //       MediaQuery.of(context).size.height,
                    //   child: DecoratedBox(
                    //     decoration: BoxDecoration(
                    //       shape: BoxShape.rectangle,
                    //       color: Theme.of(context).backgroundColor,
                    //       borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular((((bottomTarget - topTarget)/2)*MediaQuery.of(context).size.height)/2),
                    //         topRight: Radius.circular((((bottomTarget - topTarget)/2)*MediaQuery.of(context).size.height)/2),
                    //         bottomLeft: Radius.circular((((bottomTarget - topTarget)/2)*MediaQuery.of(context).size.height)/2),
                    //         bottomRight: Radius.circular((((bottomTarget - topTarget)/2)*MediaQuery.of(context).size.height)/2),
                    //       ),
                    //       border: Border.all(
                    //         color: Colors.green,
                    //         width: 20,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                  Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment(0, 1 + heroY),
                      child: Image.network(
                        widget.hero?.imageURL ?? "",
                        width: 80,
                        height: 80,
                        errorBuilder: (context, error, stack) => Image.asset(
                          KAssets.IMG_TAMAGO_CHAN,
                          width: 80,
                          height: 80,
                          package: 'app_core',
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: jump,
          child: Container(
            width: 80.0,
            height: 80.0,
            child: Image.asset(
              KAssets.IMG_BUTTON_GREEN,
              width: 80.0,
              height: 80.0,
              package: 'app_core',
            ),
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        SizedBox(height: 36),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text("Hero Training")),
      body: body,
    );
  }
}
