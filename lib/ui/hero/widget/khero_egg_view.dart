import 'dart:async';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

class KHeroEggView extends StatefulWidget {
  final KHero hero;

  const KHeroEggView({required this.hero});

  @override
  _KHeroEggViewState createState() => _KHeroEggViewState();
}

class _KHeroEggViewState extends State<KHeroEggView>
    with TickerProviderStateMixin {
  late Animation _eggShakeAnimation, _eggBouncingAnimation;
  late AnimationController _eggShakeAnimationController,
      _eggBouncingAnimationController;

  final Duration delay = Duration(milliseconds: 3000);

  final Duration eggBouncingDuration = Duration(milliseconds: 500);
  final Duration eggShakeDuration = Duration(milliseconds: 1000);

  final eggShakeSpeed = 1;

  bool showEgg = true;

  @override
  void initState() {
    super.initState();

    _eggBouncingAnimationController =
        AnimationController(vsync: this, duration: eggBouncingDuration)
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _eggBouncingAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _eggBouncingAnimationController.forward();
            }
          });
    _eggBouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -5.0))
        .animate(_eggBouncingAnimationController);

    this._eggShakeAnimationController = AnimationController(
      vsync: this,
      duration: eggShakeDuration,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          this._eggBouncingAnimationController.stop();
          this._eggBouncingAnimationController.reset();
          Future.delayed(delay, () {
            if (mounted) {
              _eggShakeAnimationController.reset();
              _eggShakeAnimationController.forward();
            }
          });
        }
      });
    this._eggShakeAnimation = Tween<double>(
      begin: 0.0,
      end: 80.0,
    ).animate(_eggShakeAnimationController);

    this._eggShakeAnimationController.forward();
    this._eggBouncingAnimationController.forward();
  }

  @override
  void dispose() {
    this._eggShakeAnimationController.dispose();
    this._eggBouncingAnimationController.dispose();
    super.dispose();
  }

  Vector.Vector3 eggShakeTransformValue() {
    final progress = this._eggShakeAnimationController.value;
    final offset = Math.sin(progress * Math.pi * this.eggShakeSpeed);
    return Vector.Vector3(offset * 8.0, 0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final eggView = Container(
      width: 64,
      child: AnimatedOpacity(
        duration: Duration(seconds: 1),
        opacity: this.showEgg ? 1.0 : 0.0,
        child: Image.network(
          widget.hero.eggImageURL ?? "",
          errorBuilder: (context, error, stack) => Image.asset(
            KAssets.IMG_HERO_EGG,
            package: 'app_core',
          ),
          // color: Theme.of(context).iconTheme.color,
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

    final body = animatedEgg;

    return body;
  }
}
