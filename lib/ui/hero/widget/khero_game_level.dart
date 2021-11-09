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

class KHeroGameLevel extends StatefulWidget {
  final KHero? hero;
  final VoidCallback? onFinish;

  const KHeroGameLevel({this.onFinish, this.hero});

  @override
  _KHeroGameLevelState createState() => _KHeroGameLevelState();
}

class _KHeroGameLevelState extends State<KHeroGameLevel>
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

  int eggBreakStep = 1;

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
    final eggStep1 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 1 ? 1.0 : 0.0,
      child: this.eggBreakStep == 1
          ? Transform.scale(
        scale: 0.5,
        child: KImageAnimation(
          animationType: KImageAnimationType.ZOOM_SHAKE,
          imageUrls: [
            KAssets.IMG_TAMAGO_1,
          ],
          isAssetImage: true,
          maxLoop: 1,
          onFinish: () {
            Future.delayed(Duration(milliseconds: 750), () {
              this.setState(() {
                this.eggBreakStep = this.eggBreakStep + 1;
              });

              Future.delayed(Duration(milliseconds: 1000), () {
                this.setState(() {
                  this.eggBreakStep = this.eggBreakStep + 1;
                });

                Future.delayed(Duration(milliseconds: 1000), () {
                  if (this.widget.onFinish != null)
                    this.widget.onFinish!();
                });
              });
            });
          },
        ),
      )
          : Container(),
    );

    final eggStep2 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 2 ? 1.0 : 0.0,
      child: this.eggBreakStep == 2
          ? Transform.scale(
        scale: 0.5,
        child: Image.asset(
          KAssets.IMG_TAMAGO_2,
          package: 'app_core',
        ),
      )
          : Container(),
    );

    final eggStep3 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 3 ? 1.0 : 0.0,
      child: this.eggBreakStep == 3
          ? Transform.scale(
        scale: 0.5,
        child: Image.asset(
          KAssets.IMG_TAMAGO_3,
          package: 'app_core',
        ),
      )
          : Container(),
    );

    final content = Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: eggStep1,
        ),
        Align(
          alignment: Alignment.center,
          child: eggStep2,
        ),
        Align(
          alignment: Alignment.center,
          child: eggStep3,
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
