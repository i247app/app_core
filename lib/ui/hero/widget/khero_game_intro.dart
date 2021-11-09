import 'dart:async';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/model/khero.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/header/kassets.dart';

class KGameIntro extends StatefulWidget {
  final KHero? hero;
  final Function? onFinish;

  const KGameIntro({this.hero, this.onFinish});

  @override
  _KGameIntroState createState() => _KGameIntroState();
}

class _KGameIntroState extends State<KGameIntro>
    with TickerProviderStateMixin {
  late Animation<double> _shakeTheTopAnimation,
      _barrelMovingAnimation,
      _barrelHeroMovingAnimation;
  late AnimationController _shakeTheTopAnimationController,
      _barrelMovingAnimationController,
      _barrelHeroMovingAnimationController,
      _barrelHeroSpinAnimationController;

  double initialPos = 1;
  double height = 0;
  double time = 0;
  double gravity = 0.0;
  double velocity = 3.5;
  Timer? _timer;
  double bulletWidth = 40;
  double bulletHeight = 40;
  double heroHeight = 40;
  double heroWidth = 40;
  double bulletSpeed = 0.01;
  bool isShooting = false;
  List<double> bulletsY = [];
  List<double> bulletsTime = [];

  int introShakeTime = 2;

  @override
  void initState() {
    super.initState();

    this._shakeTheTopAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (introShakeTime > 0 && mounted) {
          if (status == AnimationStatus.completed) {
            if (introShakeTime - 1 == 0) {
              this.fire();
            }
            _shakeTheTopAnimationController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            Future.delayed(Duration(milliseconds: 1000), () {
              if (introShakeTime - 1 > 0) {
                this._shakeTheTopAnimationController.forward();
              } else {
                Future.delayed(Duration(milliseconds: 1000), () {
                  this._barrelHeroMovingAnimationController.reverse();
                  this._barrelHeroSpinAnimationController.repeat();
                });
              }
              if (introShakeTime > 0)
                this.setState(() => introShakeTime = introShakeTime - 1);
            });
          }
        }
      });
    this._shakeTheTopAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(_shakeTheTopAnimationController);

    _barrelMovingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 1000), () {
            setState(() {
              time = 0;
            });
            // this.fire();
            this._shakeTheTopAnimationController.forward();
          });
        } else if (mounted && status == AnimationStatus.dismissed) {}
      });
    _barrelMovingAnimation = new Tween(
      begin: -1.5,
      end: 0.0,
    ).animate(new CurvedAnimation(
        parent: _barrelMovingAnimationController, curve: Curves.linear));

    _barrelHeroMovingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
        } else if (mounted && status == AnimationStatus.dismissed) {
          this._barrelHeroSpinAnimationController.stop();
          this._barrelHeroSpinAnimationController.reset();
          if (this.widget.onFinish != null) this.widget.onFinish!();
        }
      });
    _barrelHeroMovingAnimation = new Tween(
      begin: -1.5,
      end: 0.0,
    ).animate(new CurvedAnimation(
        parent: _barrelHeroMovingAnimationController, curve: Curves.linear));

    _barrelHeroSpinAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (mounted && status == AnimationStatus.completed) {
            } else if (status == AnimationStatus.dismissed) {}
          });

    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      for (int i = 0; i < bulletsY.length; i++) {
        double bulletY = bulletsY[i];
        double bulletTime = bulletsTime[i];

        height = gravity * bulletTime * bulletTime + velocity * bulletTime;
        final pos = initialPos - height;
        if (pos <= -2) {
          setState(() {
            bulletsY.removeAt(i);
            bulletsTime.removeAt(i);
          });
          return;
        } else if (pos < 1) {
          setState(() {
            bulletsY[i] = pos;
          });
        } else {
          setState(() {
            bulletsY[i] = 1;
          });
        }

        setState(() {
          bulletsTime[i] += bulletSpeed;
        });
      }
    });

    Future.delayed(Duration(milliseconds: 1500), () {
      this._barrelMovingAnimationController.forward();
      this._barrelHeroMovingAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeTheTopAnimationController.dispose();
    _barrelMovingAnimationController.dispose();
    _barrelHeroMovingAnimationController.dispose();
    _barrelHeroSpinAnimationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void fire() {
    if (!isShooting && bulletsY.length < 3) {
      setState(() {
        bulletsY = [
          ...bulletsY,
          1,
        ];
        bulletsTime = [
          ...bulletsTime,
          0,
        ];
        isShooting = true;
      });
      Future.delayed(Duration(milliseconds: 10), () {
        setState(() {
          isShooting = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      fit: StackFit.expand,
      children: [
        ...List.generate(
          bulletsY.length,
          (i) => Align(
            alignment: Alignment(0, bulletsY[i]),
            child: Container(
              width: bulletWidth,
              height: bulletWidth,
              child: Image.asset(
                KAssets.IMG_TAMAGO_LIGHT_4,
                width: bulletWidth,
                height: bulletWidth,
                package: 'app_core',
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(_barrelHeroMovingAnimation.value, 1),
          child: Transform.translate(
            offset: Offset(-heroWidth * 2 + 15, 0),
            child: Container(
              transform:
                  Matrix4.rotationZ(_shakeTheTopAnimation.value * Math.pi),
              transformAlignment: Alignment.bottomCenter,
              width: heroWidth * 2,
              height: heroHeight * 2,
              child: Transform.rotate(
                angle: -this._barrelHeroSpinAnimationController.value *
                    4 *
                    Math.pi,
                child: Image.asset(
                  KAssets.IMG_TAMAGO_CHAN,
                  width: heroWidth * 2,
                  height: heroHeight * 2,
                  package: 'app_core',
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(_barrelMovingAnimation.value, 1),
          child: Container(
            width: heroWidth * 2,
            height: heroHeight * 2,
            child: Image.asset(
              KAssets.IMG_CANNON_BARREL,
              width: heroWidth * 2,
              height: heroHeight * 2,
              package: 'app_core',
            ),
          ),
        ),
      ],
    );

    return body;
  }
}
