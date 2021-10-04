import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/kimage_animation_parameters.dart';
import 'package:app_core/header/kassets.dart';
import 'package:vector_math/vector_math_64.dart';

class DropBounceShakeImage extends StatefulWidget {
  final List<String> imageUrls;
  final KImageAnimationParameters? animationPreset;

  const DropBounceShakeImage(this.imageUrls, {this.animationPreset});

  @override
  _DropBounceShakeImageState createState() => _DropBounceShakeImageState();
}

class _DropBounceShakeImageState extends State<DropBounceShakeImage>
    with TickerProviderStateMixin {
  late AnimationController _shakeAnimationController,
      _dropBounceAnimationController;

  late Animation _shakeAnimation;
  late SpringSimulation _dropBounceAnimationSimulation;

  KImageAnimationParameters? get currentPreset => widget.animationPreset;

  List<String> get imageUrls => widget.imageUrls;

  int directionX = Math.Random().nextDouble() > 0.5 ? 1 : -1;
  int directionY = Math.Random().nextDouble() > 0.5 ? 1 : -1;

  double get maxX => (11.0 + Math.Random().nextDouble() * 1);

  double get maxY => (11.0 + Math.Random().nextDouble() * 1);

  double get randHorizontal =>
      ((currentPreset?.speed ?? 6.0) + Math.Random().nextDouble() * 1);

  double get randVertical =>
      ((currentPreset?.speed ?? 6.0) + Math.Random().nextDouble() * 1);

  int imageIndex = 0;
  int loopTime = 0;

  bool isShowImage = false;

  double get heroSize => 120;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.loopTime = currentPreset!.maxLoop ?? 0;

    this._dropBounceAnimationSimulation = SpringSimulation(
      SpringDescription(
        mass: 1,
        stiffness: 60,
        damping: 8,
      ),
      0.0, // starting point
      400.0, // ending point
      1, // velocity
    );
    this._dropBounceAnimationController =
        AnimationController(vsync: this, upperBound: 500.0)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (mounted && status == AnimationStatus.completed) {
              this._shakeAnimationController.forward();
              if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);
            }
          });

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

          if (currentPreset!.maxLoop == 0 || loopTime > 0) {
            Future.delayed(Duration(milliseconds: 500), () {
              if (mounted) {
                int newIndex = imageIndex + 1;
                if (newIndex < imageUrls.length) {
                  this.setState(() => imageIndex = newIndex);
                } else if (imageIndex > 0) {
                  this.setState(() => imageIndex = 0);
                }
              }
            });
            Future.delayed(
                Duration(milliseconds: 1000 + Math.Random().nextInt(1500)), () {
              if (mounted) {
                this._shakeAnimationController.forward();
                if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);
              }
            });
          }
        }
      });
    this._shakeAnimation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(_shakeAnimationController);

    Future.delayed(Duration(milliseconds: 1500), () {
      if (mounted) {
        this.setState(() => this.isShowImage = true);
        this
            ._dropBounceAnimationController
            .animateWith(this._dropBounceAnimationSimulation);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      this._shakeAnimationController.dispose();
    } catch (ex) {}
    try {
      this._dropBounceAnimationController.dispose();
    } catch (ex) {}
    super.dispose();
  }

  Vector3 shakeTransformValue() {
    if (currentPreset != null && (currentPreset!.isRandom ?? false)) {
      final progress = this._shakeAnimationController.value;
      final offsetX =
          Math.sin(progress * Math.pi * randHorizontal) * directionX;
      final offsetY = (currentPreset?.isHorizontal ?? false)
          ? 0
          : Math.sin(progress * Math.pi * randVertical) * directionY;
      return Vector3(offsetX * maxX, offsetY * maxY, 0.0);
    } else {
      final progress = this._shakeAnimationController.value;
      final offsetX =
          Math.sin(progress * Math.pi * (currentPreset?.speed ?? 8.0));
      final offsetY = (currentPreset?.isHorizontal ?? false)
          ? 0
          : Math.sin(progress * Math.pi * (currentPreset?.speed ?? 8.0));
      return Vector3(offsetX * 10.0, offsetY * 10.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final animation = Opacity(
      opacity: isShowImage ? 1 : 0,
      child: Container(
        transform: Matrix4.translationValues(0.0, -400, 0.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          transform: Matrix4.translationValues(
              0.0, this._dropBounceAnimationController.value, 0.0),
          child: Transform(
            transform: Matrix4.translation(shakeTransformValue()),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.network(
                    imageUrls[imageIndex],
                    height: heroSize,
                    errorBuilder: (context, error, stack) => Image.asset(
                      KAssets.HERO_EGG,
                      height: heroSize,
                      package: 'app_core',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return animation;
  }
}
