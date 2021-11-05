import 'dart:async';
import 'dart:math' as Math;

import 'package:app_core/header/kassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/app_core.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

class KHeroPortrait extends StatefulWidget {
  final KHero hero;

  const KHeroPortrait({required this.hero});

  @override
  _KHeroPortraitState createState() => _KHeroPortraitState();
}

class _KHeroPortraitState extends State<KHeroPortrait>
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

  final Duration eggBouncingDuration = Duration(milliseconds: 300);
  final Duration adultBouncingDuration = Duration(seconds: 1);
  final Duration eggShakeDuration = Duration(seconds: 1);
  final Duration adultShakeDuration = Duration(seconds: 1);
  final Duration flashingDuration = Duration(milliseconds: 1500);

  // bool showAdult = false;
  // bool showEgg = true;
  late bool showAdult = !widget.hero.isEgg;
  late bool showEgg = widget.hero.isEgg;

  int shakeTime = 0;
  int maxShakeTime = 2;
  bool showFlashing = false;
  bool wasJustBorn = false;

  @override
  void initState() {
    super.initState();
    setupAnimation();
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

  @override
  void didUpdateWidget(covariant KHeroPortrait oldWidget) {
    super.didUpdateWidget(oldWidget);
    try {
      print("HERO id ${oldWidget.hero.id} >>>> ${widget.hero.id}");
      print("HERO isEgg ${oldWidget.hero.isEgg} >>>> ${widget.hero.isEgg}");

      // Check if a hatch was initiated
      if (oldWidget.hero.id == widget.hero.id &&
          oldWidget.hero.isEgg &&
          !widget.hero.isEgg) {
        setupAnimation();
        startAnimation();
      } else {
        setState(() {
          this.showAdult = !widget.hero.isEgg;
          this.showEgg = widget.hero.isEgg;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void setupAnimation() {
    _adultBouncingAnimationController =
        AnimationController(vsync: this, duration: adultBouncingDuration)
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              this._adultBouncingAnimationController.reset();
            }
          });
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
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          this._adultShakeAnimationController.reset();
        }
      });
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
            _eggShakeAnimationController.reset();
            _flashingAnimationController.repeat(reverse: false);
            this.setState(() {
              this.showFlashing = true;
              this.showEgg = false;
            });
            Future.delayed(flashingDuration, () {
              this.setState(() {
                this.showFlashing = false;
                this.showAdult = true;
              });
              Future.delayed(delay, () {
                _flashingAnimationController.stop();
                _flashingAnimationController.reset();
                _adultShakeAnimationController.forward();
                _adultBouncingAnimationController.forward();
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

    setState(() {});
  }

  void startAnimation() {
    this._eggShakeAnimationController.forward();
    this._eggBouncingAnimationController.forward();
  }

  Vector.Vector3 eggShakeTransformValue() {
    final progress = this._eggShakeAnimationController.value;
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
        duration: Duration(seconds: 1),
        opacity: this.showEgg ? 1.0 : 0.0,
        child: Image.network(
          widget.hero.eggImageURL ?? "",
          color: Theme.of(context).iconTheme.color,
          errorBuilder: (context, error, stack) => Image.asset(
            KAssets.HERO_EGG,
            package: 'app_core',
          ),
        ),
      ),
    );

    final adultView = Container(
      width: 128,
      child: AnimatedOpacity(
        duration: Duration(seconds: 1),
        opacity: this.showAdult ? 1.0 : 0.0,
        child: Image.network(
          widget.hero.imageURL ?? "",
          errorBuilder: (context, error, stack) => Image.asset(
            KAssets.HERO_EGG,
            package: 'app_core',
          ),
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

    final body = Stack(
      children: [
        content,
        if (this.showFlashing)
          Align(
            alignment: Alignment.center,
            child: flashing,
          ),
      ],
    );

    return body;
  }
}
