import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/kimage_animation_parameters.dart';
import 'package:app_core/header/kassets.dart';

class ShakeTheTopImage extends StatefulWidget {
  final List<String> imageUrls;
  final KImageAnimationParameters? animationPreset;

  const ShakeTheTopImage(this.imageUrls, {this.animationPreset});

  @override
  _ShakeTheTopImageState createState() => _ShakeTheTopImageState();
}

class _ShakeTheTopImageState extends State<ShakeTheTopImage>
    with TickerProviderStateMixin {
  late AnimationController _shakeAnimationController;
  late Animation _shakeAnimation;

  KImageAnimationParameters? get currentPreset => widget.animationPreset;

  List<String> get imageUrls => widget.imageUrls;

  final Duration shakeDuration = Duration(milliseconds: 200);

  int imageIndex = 0;
  int loopTime = 0;

  double get heroSize => currentPreset?.size ?? 120;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.loopTime = currentPreset!.maxLoop ?? 0;

    this._shakeAnimationController = AnimationController(
      vsync: this,
      duration: shakeDuration,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (currentPreset!.maxLoop == 0 || loopTime > 0 && mounted) {
          if (status == AnimationStatus.completed) {
            int newIndex = imageIndex + 1;
            if (newIndex < imageUrls.length) {
              this.setState(() => imageIndex = newIndex);
            } else if (imageIndex > 0) {
              this.setState(() => imageIndex = 0);
            }
            if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);

            _shakeAnimationController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            int newIndex = imageIndex + 1;
            if (newIndex < imageUrls.length) {
              this.setState(() => imageIndex = newIndex);
            } else if (imageIndex > 0) {
              this.setState(() => imageIndex = 0);
            }
            if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);

            _shakeAnimationController.forward();
          }
        } else if (currentPreset!.maxLoop != 0 &&
            loopTime <= 0 &&
            (status == AnimationStatus.completed ||
                status == AnimationStatus.dismissed) &&
            currentPreset!.onFinish != null) {
          currentPreset!.onFinish!();
        }
      });
    this._shakeAnimation = Tween<double>(
      begin: -0.015,
      end: 0.015,
    ).animate(_shakeAnimationController);

    Future.delayed(
      Duration(milliseconds: 700),
      () {
        if (mounted) {
          this._shakeAnimationController.forward();
          if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      this._shakeAnimationController.dispose();
    } catch (ex) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Container(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Container(
          transform: Matrix4.rotationZ(_shakeAnimation.value * Math.pi),
          transformAlignment: Alignment.bottomCenter,
          child: (currentPreset?.isAssetImage ?? false)
              ? Image.asset(
                  imageUrls[imageIndex],
                  height: heroSize,
                  package: 'app_core',
                )
              : Image.network(
                  imageUrls[imageIndex],
                  height: heroSize,
                  errorBuilder: (context, error, stack) => Image.asset(
                    KAssets.IMG_HERO_EGG,
                    height: heroSize,
                    package: 'app_core',
                  ),
                ),
        ),
      ),
    );

    return animation;
  }
}
