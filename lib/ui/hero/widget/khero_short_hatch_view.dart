import 'dart:async';
import 'dart:math' as Math;

import 'package:app_core/helper/kimage_animation_helper.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/header/kassets.dart';
import 'package:app_core/ui/widget/kimage_animation/kimage_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

class KHeroShortHatchView extends StatefulWidget {
  final KHero hero;
  final VoidCallback? onFinish;

  const KHeroShortHatchView({this.onFinish, required this.hero});

  @override
  _KHeroShortHatchViewState createState() => _KHeroShortHatchViewState();
}

class _KHeroShortHatchViewState extends State<KHeroShortHatchView>
    with TickerProviderStateMixin {
  late Animation _adultShakeAnimation, _adultBouncingAnimation;
  late AnimationController _adultShakeAnimationController,
      _adultBouncingAnimationController,
      _flashingAnimationController;

  final List<String> heroImageUrls =
  List.generate(1, (_) => KImageAnimationHelper.randomImage);

  final Duration delay = Duration(milliseconds: 200);

  final Duration eggBouncingDuration = Duration(milliseconds: 500);

  final Duration adultBouncingDuration = Duration(milliseconds: 750);
  final Duration adultShakeDuration = Duration(milliseconds: 750);

  final Duration flashingDuration = Duration(milliseconds: 500);

  int imageUrlIndex = 0;
  bool showAdult = false;
  bool showEgg = true;
  bool showFlashing = false;
  int eggBreakStep = 1;

  @override
  void initState() {
    super.initState();

    _adultBouncingAnimationController = AnimationController(vsync: this, duration: adultBouncingDuration)
        ..addListener(() => setState(() {}));
    _adultBouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -10.0))
        .animate(_adultBouncingAnimationController);

    _flashingAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250))
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
            Future.delayed(delay, () {
              this.setState(() {
                this.imageUrlIndex = this.imageUrlIndex + 1;
              });
              _adultShakeAnimationController.forward();
              _adultBouncingAnimationController.forward();
            });
          } else {
            Future.delayed(Duration(milliseconds: 500), () {
              if (this.widget.onFinish != null) this.widget.onFinish!();
            });
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
      duration: Duration(milliseconds: 1500),
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
        duration: Duration(milliseconds: 0),
        opacity: this.showAdult ? 1.0 : 0.0,
        child: this.showAdult ? KImageAnimation(
          imageUrls: [widget.hero.imageURL!],
          animationType: KImageAnimationType.TINY_ZOOM_SHAKE,
          maxLoop: 1,
          onFinish: () => Future.delayed(
            Duration(milliseconds: 1000),
            widget.onFinish,
          ),
        ) : Container(),
      ),
    );

    final eggStep1 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.showEgg && this.eggBreakStep == 1 ? 1.0 : 0.0,
      child: this.eggBreakStep == 1
          ? Transform.scale(
        scale: 0.5,
        child: KImageAnimation(
          animationType: KImageAnimationType.SHAKE_THE_TOP,
          imageUrls: [
            KAssets.IMG_TAMAGO_1,
          ],
          isAssetImage: true,
          maxLoop: 2,
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
                  this.setState(() {
                    this.eggBreakStep = this.eggBreakStep + 1;
                  });

                  Future.delayed(Duration(milliseconds: 1500), () {
                    this.setState(() {
                      this.eggBreakStep = this.eggBreakStep + 1;
                      this.showAdult = true;
                    });
                  });
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
      opacity: this.showEgg && this.eggBreakStep == 2 ? 1.0 : 0.0,
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
      opacity: this.showEgg && this.eggBreakStep == 3 ? 1.0 : 0.0,
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

    final eggStep4 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.showEgg && this.eggBreakStep == 4 ? 1.0 : 0.0,
      child: this.eggBreakStep == 4
          ? Transform.scale(
        scale: 0.5,
        child: Image.asset(
          KAssets.IMG_TAMAGO_4,
          package: 'app_core',
        ),
      )
          : Container(),
    );

    // final animatedEgg = AnimatedOpacity(
    //   duration: Duration(seconds: 1),
    //   opacity: this.showEgg ? 1.0 : 0.0,
    //   child: KImageAnimation(
    //     animationType: KImageAnimationType.SHAKE_THE_TOP,
    //     imageUrls: [Assets.IMG_TAMAGO_1],
    //     maxLoop: 3,
    //     onFinish: () {
    //     },
    //   ),
    // );

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
        Align(
          alignment: Alignment.center,
          child: eggStep4,
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
        // if (this.showFlashing)
        //   Align(
        //     alignment: Alignment.center,
        //     child: flashing,
        //   ),
      ],
    );
  }
}
