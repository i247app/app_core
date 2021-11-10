import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/kimage_animation_parameters.dart';
import 'package:app_core/header/kassets.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

class ZoomShakeImage extends StatefulWidget {
  final List<String> imageUrls;
  final KImageAnimationParameters? animationPreset;

  const ZoomShakeImage(this.imageUrls, {this.animationPreset});

  @override
  _ZoomShakeImageState createState() => _ZoomShakeImageState();
}

class _ZoomShakeImageState extends State<ZoomShakeImage>
    with TickerProviderStateMixin {
  late Animation _shakeAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _scaleAnimationController, _shakeAnimationController;

  static const MAX_SHAKE_TIME = 1;

  final Duration scaleDuration = Duration(milliseconds: 1000);
  final Duration shakeDuration = Duration(milliseconds: 1000);
  final Duration delay = Duration(milliseconds: 3000);

  KImageAnimationParameters? get currentPreset => widget.animationPreset;

  List<String> get imageUrls => widget.imageUrls;

  int shakeTime = MAX_SHAKE_TIME;
  int imageIndex = 0;
  int loopTime = 0;

  double get shakeSpeed => currentPreset?.speed ?? 8.0;

  double get heroSize => 100;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.loopTime = currentPreset!.maxLoop ?? 0;

    _scaleAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          this.setState(() {
            this.shakeTime = this.shakeTime - 1;
          });
          this._shakeAnimationController.forward();
        } else if (mounted && status == AnimationStatus.dismissed) {
          if (currentPreset!.maxLoop != 0 &&
              loopTime == 0 &&
              currentPreset!.onFinish != null) {
            currentPreset!.onFinish!();
          }
        }
      });
    _scaleAnimation = new Tween(
      begin: 1.0,
      end: 2.0,
    ).animate(new CurvedAnimation(
        parent: _scaleAnimationController, curve: Curves.bounceOut));

    this._shakeAnimationController = AnimationController(
      vsync: this,
      duration: shakeDuration,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          if (shakeTime > 0) {
            this.setState(() {
              this.shakeTime = this.shakeTime - 1;
            });
            Future.delayed(delay, () {
              if (mounted) {
                _shakeAnimationController.reset();
                _shakeAnimationController.forward();
              }
            });
          } else {
            _shakeAnimationController.reset();
            _scaleAnimationController.reverse();
            this.shakeTime = MAX_SHAKE_TIME;
            //
            // if (currentPreset!.maxLoop == 0 || loopTime > 0) {
            //   if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);
            //
            //   int newIndex = imageIndex + 1;
            //   if (newIndex < imageUrls.length) {
            //     this.setState(() => imageIndex = newIndex);
            //   } else if (imageIndex > 0) {
            //     this.setState(() => imageIndex = 0);
            //   }
            //
            //   Future.delayed(
            //     Duration(milliseconds: 700),
            //         () {
            //       if (mounted) {
            //         this._scaleAnimationController.forward();
            //       }
            //     },
            //   );
            // }
          }
        }
      });
    this._shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 80.0,
    ).animate(_shakeAnimationController);

    Future.delayed(Duration(milliseconds: 1000), () {
      if (mounted) {
        if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);
        this._scaleAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      this._scaleAnimationController.dispose();
      this._shakeAnimationController.dispose();
    } catch (ex) {}
    super.dispose();
  }

  Vector.Vector3 shakeTransformValue() {
    final progress = this._shakeAnimationController.value;
    final offset = Math.sin(progress * Math.pi * this.shakeSpeed);
    return Vector.Vector3(offset * 8.0, 0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final animation = Container(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Transform(
                  transform: Matrix4.translation(shakeTransformValue()),
                  child: Image.network(
                    imageUrls[imageIndex],
                    height: heroSize,
                    errorBuilder: (context, error, stack) => Image.asset(
                      widget.imageUrls.length > 0 ? widget.imageUrls[0] : KAssets.IMG_HERO_EGG,
                      height: heroSize,
                      package: 'app_core',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return animation;
  }
}
