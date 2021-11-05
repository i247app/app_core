import 'dart:async';
import 'dart:math' as Math;

import 'package:app_core/header/kassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/khero.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

class KHeroHatchView extends StatefulWidget {
  final KHero hero;
  final VoidCallback? onFinish;

  const KHeroHatchView({
    required this.hero,
    this.onFinish,
  });

  @override
  _KHeroHatchViewState createState() => _KHeroHatchViewState();
}

class _KHeroHatchViewState extends State<KHeroHatchView>
    with TickerProviderStateMixin {
  late Animation _eggShakeAnimation,
      _eggBouncingAnimation,
      _adultShakeAnimation,
      _adultBouncingAnimation;
  late AnimationController _eggShakeAnimationController,
      _eggBouncingAnimationController,
      _adultShakeAnimationController,
      _adultBouncingAnimationController,
      _flashingAnimationController;

  final Duration delay = Duration(milliseconds: 500);

  final Duration eggBouncingDuration = Duration(milliseconds: 500);
  final Duration eggShakeDuration = Duration(milliseconds: 1000);

  final Duration adultBouncingDuration = Duration(milliseconds: 1000);
  final Duration adultShakeDuration = Duration(milliseconds: 1000);

  final Duration flashingDuration = Duration(milliseconds: 500);

  final eggShakeSpeed = 4;

  int shakeTime = 0;
  int maxShakeTime = 2;
  bool showAdult = false;
  bool showEgg = true;
  bool showFlashing = false;

  @override
  void initState() {
    super.initState();

    _adultBouncingAnimationController =
        AnimationController(vsync: this, duration: adultBouncingDuration)
          ..addListener(() => setState(() {}));
    _adultBouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -10.0))
        .animate(_adultBouncingAnimationController);

    _eggBouncingAnimationController =
        AnimationController(vsync: this, duration: eggBouncingDuration)
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (showEgg) {
              if (status == AnimationStatus.completed) {
                _eggBouncingAnimationController.reverse();
              } else if (status == AnimationStatus.dismissed) {
                _eggBouncingAnimationController.forward(from: 0.0);
              }
            }
          });

    _eggBouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -10.0))
        .animate(_eggBouncingAnimationController);

    _flashingAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250))
          ..addListener(() => setState(() {}));

    this._adultShakeAnimationController = AnimationController(
      vsync: this,
      duration: adultShakeDuration,
    )..addListener(() => setState(() {}));

    this._adultShakeAnimation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(_adultShakeAnimationController);

    this._eggShakeAnimationController = AnimationController(
      vsync: this,
      duration: eggShakeDuration,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (shakeTime + 1 >= maxShakeTime) {
            _flashingAnimationController.repeat(reverse: false);
            this.setState(() {
              this.showFlashing = true;
              this.showEgg = false;

              this.showAdult = true;
            });

            Future.delayed(flashingDuration, () {
              this.setState(() {
                this.showFlashing = false;
                this.showAdult = true;
              });

              Future.delayed(delay, () {
                _flashingAnimationController.stop();
                _adultShakeAnimationController.forward();
                _adultBouncingAnimationController.forward();
                Future.delayed(Duration(milliseconds: 1500), () {
                  if (this.widget.onFinish != null) this.widget.onFinish!();
                });
              });
            });
          } else {
            this.setState(() {
              this.shakeTime = this.shakeTime + 1;
            });

            Future.delayed(delay, () {
              if (mounted) {
                _eggShakeAnimationController.reset();
                _eggShakeAnimationController.forward();
              }
            });
          }
        }
      });
    this._eggShakeAnimation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(_eggShakeAnimationController);

    // Preload the images before running the animation
    Future.delayed(Duration.zero).whenComplete(
      () => Future.wait([
        precacheImage(NetworkImage(widget.hero.imageURL ?? ""), context),
        precacheImage(NetworkImage(widget.hero.eggImageURL ?? ""), context),
      ]).whenComplete(startAnimation),
    );
  }

  @override
  void dispose() {
    this._eggShakeAnimationController.dispose();
    this._eggBouncingAnimationController.dispose();
    this._adultShakeAnimationController.dispose();
    this._adultBouncingAnimationController.dispose();
    this._flashingAnimationController.dispose();
    super.dispose();
  }

  void startAnimation() {
    this._eggShakeAnimationController.forward();
    this._eggBouncingAnimationController.forward();
  }

  Vector.Vector3 eggShakeTransformValue() {
    final progress = this._eggShakeAnimationController.value;
    // final offset = Math.sin(progress * Math.pi * this.eggShakeSpeed);
    final offset = Math.sin(progress * Math.pi * 8.0);
    return Vector.Vector3(offset * 8.0, 0.0, 0.0);
  }

  Vector.Vector3 adultShakeTransformValue() {
    final progress = this._adultShakeAnimationController.value;
    final offset = Math.sin(progress * Math.pi * 8.0);
    return Vector.Vector3(offset * 8.0, 0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final flashing = AnimatedOpacity(
      duration: Duration(milliseconds: 1500),
      opacity: this.showFlashing ? 1.0 : 0.0,
      child: Container(
        color: _flashingAnimationController.value < 0.5
            ? Colors.black
            : Colors.white,
      ),
    );

    final eggView = Container(
      width: 128,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 800),
        opacity: this.showEgg ? 1.0 : 0.0,
        child: Image.network(widget.hero.eggImageURL ?? "",
            errorBuilder: (context, error, stack) => Image.asset(
                  KAssets.HERO_EGG,
                  package: 'app_core',
                  height: MediaQuery.of(context).size.height * 0.6,
                )
            // color: Theme.of(context).iconTheme.color,
            ),
      ),
    );

    final adultView = Container(
      width: 128,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 800),
        opacity: this.showAdult ? 1.0 : 0.0,
        child: Image.network(
          widget.hero.imageURL ?? "",
          errorBuilder: (context, error, stack) => Container(),
        ),
      ),
    );

    final animatedEgg = Transform.translate(
      offset: _eggBouncingAnimation.value,
      child: Transform(
        transform: Matrix4.translation(eggShakeTransformValue()),
        child: eggView,
      ),
    );

    final animatedAdult = Transform.translate(
      offset: _adultBouncingAnimation.value,
      child: Transform(
        transform: Matrix4.translation(adultShakeTransformValue()),
        child: adultView,
      ),
    );

    final content = Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: animatedEgg,
        ),
        Align(
          alignment: Alignment.center,
          child: animatedAdult,
        ),
      ],
    );

    final body = content;

    return Stack(
      children: [
        body,
        if (this.showFlashing)
          Align(
            alignment: Alignment.center,
            child: flashing,
          ),
      ],
    );
  }
}
