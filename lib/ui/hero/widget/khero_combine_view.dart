import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/model/khero.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as Vector64;

class KHeroCombineView extends StatefulWidget {
  final KHero hero;
  final KHero dragHero;
  final VoidCallback? onFinish;

  const KHeroCombineView({
    required this.hero,
    required this.dragHero,
    this.onFinish,
  });

  @override
  _KHeroCombineViewState createState() => _KHeroCombineViewState();
}

class _KHeroCombineViewState extends State<KHeroCombineView>
    with TickerProviderStateMixin {
  late Animation _combineAnimation, _shakeAnimation;
  late AnimationController _spinAnimationController,
      _combineAnimationController,
      _flashingAnimationController,
      _shakeAnimationController;

  final Duration flashingDuration = Duration(milliseconds: 1000);
  final double heroSize = 120;

  double get maxX => (11.0 + Math.Random().nextDouble() * 1);

  double get randHorizontal => (6.0 + Math.Random().nextDouble() * 1);

  bool showFlashing = false;
  bool showHero = false;
  bool showCombining = false;
  bool isSpinning = Math.Random().nextBool();

  int directionX = Math.Random().nextDouble() > 0.5 ? 1 : -1;
  int directionY = Math.Random().nextDouble() > 0.5 ? 1 : -1;
  int loopTime = 0;
  int maxLoop = 1;

  @override
  void initState() {
    super.initState();

    this._flashingAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250))
          ..addListener(() => setState(() {}));

    this._combineAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          setState(() {
            this.showCombining = false;
            this.showFlashing = true;
          });
          Future.delayed(Duration(milliseconds: 200), () {
            setState(() {
              this.showHero = true;
            });
          });

          this._spinAnimationController.reset();
          this._flashingAnimationController.repeat(reverse: false);
          Future.delayed(flashingDuration, () {
            setState(() => this.showFlashing = false);
            this._flashingAnimationController.reset();
          });
        }
      });
    this._combineAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(new CurvedAnimation(
        parent: _combineAnimationController, curve: Curves.bounceOut));

    _spinAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() => setState(() {}));

    this._shakeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          _shakeAnimationController.reset();

          this.setState(() {
            this.directionX = Math.Random().nextDouble() > 0.5 ? 1 : -1;
            this.directionY = Math.Random().nextDouble() > 0.5 ? 1 : -1;
          });

          if (maxLoop == 0 || loopTime > 0) {
            Future.delayed(
                Duration(milliseconds: 1000 + Math.Random().nextInt(1500)), () {
              if (mounted) {
                this._shakeAnimationController.forward();
                if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);
              }
            });
          } else {
            this._combineAnimationController.forward();
            if (this.isSpinning) {
              this._spinAnimationController.repeat();
            }
          }
        }
      });
    this._shakeAnimation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(_shakeAnimationController);

    setState(() {
      this.showCombining = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      this._shakeAnimationController.forward();
      if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);
    });
  }

  @override
  void dispose() {
    this._flashingAnimationController.dispose();
    this._combineAnimationController.dispose();
    super.dispose();
  }

  Vector64.Vector3 shakeTransformValue() {
    final progress = this._shakeAnimationController.value;
    final offsetX = Math.sin(progress * Math.pi * randHorizontal) * directionX;
    return Vector64.Vector3(offsetX * maxX, 0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final flashing = AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: this.showFlashing ? 1.0 : 0.0,
      child: Container(
        color: _flashingAnimationController.value < 0.5
            ? Colors.black
            : Colors.white,
      ),
    );

    final heroView = KStringHelper.isExist(widget.hero.imageURL)
        ? Container(
            width: 128,
            child: KImageAnimation(
              imageUrls: [widget.hero.imageURL!],
              animationType: Math.Random().nextBool()
                  ? KImageAnimationType.ZOOM_SHAKE
                  : KImageAnimationType.ZOOM_BOUNCE,
              maxLoop: 1,
              onFinish: () => Future.delayed(
                Duration(milliseconds: 1000),
                widget.onFinish,
              ),
            ),
          )
        : Container();

    final deviceWidth = MediaQuery.of(context).size.width;
    final leftToRightAnimation = AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: this.showCombining ? 1.0 : 0.0,
      child: Container(
        transform: Matrix4.translationValues(-deviceWidth / 2 + 60, 0.0, 0.0),
        child: Container(
          height: this.heroSize,
          transform: Matrix4.translationValues(
              this._combineAnimation.value * deviceWidth -
                  this._combineAnimation.value * 120,
              0.0,
              0.0),
          child: Transform.rotate(
            angle: this._spinAnimationController.value * 2 * Math.pi,
            child: Transform(
              transform: Matrix4.translation(-shakeTransformValue()),
              child: Image.network(
                widget.dragHero.imageURL ?? "",
                height: this.heroSize,
                errorBuilder: (context, error, stack) => Image.asset(
                  KAssets.IMG_HERO_EGG,
                  height: this.heroSize,
                  package: 'app_core',
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final rightToLeftAnimation = AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: this.showCombining ? 1.0 : 0.0,
      child: Container(
        transform: Matrix4.translationValues(deviceWidth / 2 - 60, 0.0, 0.0),
        child: Container(
          height: this.heroSize,
          transform: Matrix4.translationValues(
              -this._combineAnimation.value * deviceWidth +
                  this._combineAnimation.value * 120,
              0.0,
              0.0),
          child: Transform.rotate(
            angle: -_spinAnimationController.value * 2 * Math.pi,
            child: Transform(
              transform: Matrix4.translation(shakeTransformValue()),
              child: Image.network(
                widget.hero.imageURL ?? "",
                height: this.heroSize,
                errorBuilder: (context, error, stack) => Image.asset(
                  KAssets.IMG_HERO_EGG,
                  height: this.heroSize,
                  package: 'app_core',
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Stack(
      children: [
        Align(alignment: Alignment.center, child: leftToRightAnimation),
        Align(alignment: Alignment.center, child: rightToLeftAnimation),
        if (this.showHero) Align(alignment: Alignment.center, child: heroView),
        Align(alignment: Alignment.center, child: flashing),
      ],
    );
  }
}
