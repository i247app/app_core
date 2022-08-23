import 'dart:async';
import 'dart:math' as Math;

import 'package:app_core/helper/kimage_animation_helper.dart';
import 'package:app_core/ui/widget/kimage_animation/kimage_animation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

class KHeroIntro extends StatefulWidget {
  final VoidCallback? onFinish;

  const KHeroIntro({this.onFinish});

  @override
  _KHeroIntroState createState() => _KHeroIntroState();
}

class _KHeroIntroState extends State<KHeroIntro> with TickerProviderStateMixin {
  late Animation _adultShakeAnimation, _adultBouncingAnimation;
  late AnimationController _adultShakeAnimationController,
      _adultBouncingAnimationController,
      _flashingAnimationController;

  final List<String> heroImageUrls =
      List.generate(3, (_) => KImageAnimationHelper.randomImage);

  final Duration delay = Duration(milliseconds: 200);

  final Duration eggBouncingDuration = Duration(milliseconds: 500);

  final Duration adultBouncingDuration = Duration(milliseconds: 750);
  final Duration adultShakeDuration = Duration(milliseconds: 750);

  final Duration flashingDuration = Duration(milliseconds: 500);

  int imageUrlIndex = 0;
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
          if (imageUrlIndex + 1 < heroImageUrls.length) {
            _adultShakeAnimationController.reset();
            _adultBouncingAnimationController.reset();

            this.setState(() {
              this.imageUrlIndex = this.imageUrlIndex + 1;
            });
            _adultShakeAnimationController.forward();
            _adultBouncingAnimationController.forward();
          } else {
            if (this.widget.onFinish != null) this.widget.onFinish!();
          }
        }
      });
    this._adultShakeAnimation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(_adultShakeAnimationController);
  }

  @override
  void dispose() {
    this._adultShakeAnimationController.dispose();
    this._adultBouncingAnimationController.dispose();
    this._flashingAnimationController.dispose();
    super.dispose();
  }

  Vector.Vector3 adultShakeTransformValue() {
    final progress = this._adultShakeAnimationController.value;
    final offset = Math.sin(progress * Math.pi * 8.0);
    return Vector.Vector3(offset * 8.0, 0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final flashing = AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: this.showFlashing ? 1.0 : 0.0,
      child: Container(
        color: _flashingAnimationController.value < 0.5
            ? Colors.black
            : Colors.white,
      ),
    );

    final adultView = Container(
      width: 128,
      child: AnimatedOpacity(
        duration: Duration(seconds: 1),
        opacity: this.showAdult ? 1.0 : 0.0,
        child: Image.network(
          heroImageUrls[imageUrlIndex],
          errorBuilder: (context, error, stack) => Container(),
        ),
      ),
    );

    final animatedEgg = AnimatedOpacity(
      duration: Duration(seconds: 1),
      opacity: this.showEgg ? 1.0 : 0.0,
      child: KImageAnimation(
        animationType: KImageAnimationType.SHAKE_THE_TOP,
        imageUrls: [""],
        maxLoop: 3,
        onFinish: () {
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
              _adultShakeAnimationController.forward();
              _adultBouncingAnimationController.forward();
            });
          });
        },
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
