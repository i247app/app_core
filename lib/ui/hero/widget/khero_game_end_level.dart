import 'dart:async';
import 'dart:math' as Math;

import 'package:app_core/helper/kflash_helper.dart';
import 'package:app_core/helper/kimage_animation_helper.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/header/kassets.dart';
import 'package:app_core/ui/widget/kimage_animation/kimage_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

class KHeroGameEndLevel extends StatefulWidget {
  final KHero? hero;
  final VoidCallback? onFinish;

  const KHeroGameEndLevel({this.onFinish, this.hero});

  @override
  _KHeroGameEndLevelState createState() => _KHeroGameEndLevelState();
}

class _KHeroGameEndLevelState extends State<KHeroGameEndLevel>
    with TickerProviderStateMixin {
  late Animation _adultShakeAnimation, _adultBouncingAnimation;
  late AnimationController _adultShakeAnimationController,
      _adultBouncingAnimationController;

  final List<String> heroImageUrls =
      List.generate(1, (_) => KImageAnimationHelper.randomImage);

  final Duration delay = Duration(milliseconds: 200);

  final Duration adultBouncingDuration = Duration(milliseconds: 750);
  final Duration adultShakeDuration = Duration(milliseconds: 750);

  bool showAdult = true;

  @override
  void initState() {
    super.initState();

    _adultBouncingAnimationController =
        AnimationController(vsync: this, duration: adultBouncingDuration)
          ..addListener(() => setState(() {}));
    _adultBouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -10.0))
        .animate(_adultBouncingAnimationController);

    this._adultShakeAnimationController = AnimationController(
      vsync: this,
      duration: adultShakeDuration,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {}
      });
    this._adultShakeAnimation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(_adultShakeAnimationController);

    KFlashHelper.rainConfetti();
  }

  @override
  void dispose() {
    this._adultShakeAnimationController.dispose();
    this._adultBouncingAnimationController.dispose();
    super.dispose();
  }

  Vector.Vector3 adultShakeTransformValue() {
    final progress = this._adultShakeAnimationController.value;
    final offset = Math.sin(progress * Math.pi * 8.0);
    return Vector.Vector3(offset * 8.0, 0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final adultView = Container(
      width: 128,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 0),
        opacity: this.showAdult ? 1.0 : 0.0,
        child: this.showAdult
            ? KImageAnimation(
                imageUrls: [KAssets.HERO_EGG],
                isAssetImage: true,
                animationType: KImageAnimationType.ZOOM_BOUNCE,
                maxLoop: 1,
                onFinish: () => Future.delayed(
                  Duration(milliseconds: 1000),
                  widget.onFinish,
                ),
              )
            : Container(),
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
          child: animatedAdult,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Congratulation!",style: TextStyle(color: Colors.white, fontSize: 30,),),
                Text("You Passed This Level",style: TextStyle(color: Colors.white, fontSize: 18,),),
              ],
            ),
          ),
        ),
      ],
    );

    final body = content;

    return Stack(
      children: [
        body,
      ],
    );
  }
}
