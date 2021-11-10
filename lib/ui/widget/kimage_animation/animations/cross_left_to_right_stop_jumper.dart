import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/kimage_animation_parameters.dart';
import 'package:app_core/header/kassets.dart';
import 'package:vector_math/vector_math_64.dart';

class CrossLeftToRightStopJumperImage extends StatefulWidget {
  final List<String> imageUrls;
  final KImageAnimationParameters? animationPreset;

  const CrossLeftToRightStopJumperImage(this.imageUrls, {this.animationPreset});

  @override
  _CrossLeftToRightStopJumperImageState createState() =>
      _CrossLeftToRightStopJumperImageState();
}

class _CrossLeftToRightStopJumperImageState
    extends State<CrossLeftToRightStopJumperImage>
    with TickerProviderStateMixin {
  late AnimationController _crossScreenAnimationController,
      _jumpAnimationController;

  // late SpringSimulation _crossScreenAnimationSimulation;
  late Animation _jumpAnimation, _crossScreenAnimation;

  KImageAnimationParameters? get currentPreset => widget.animationPreset;

  List<String> get imageUrls => widget.imageUrls;

  int imageIndex = 0;
  int loopTime = 0;

  double get heroSize => 120;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.loopTime = currentPreset!.maxLoop ?? 0;

    this._jumpAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          _jumpAnimationController.reverse();
          Future.delayed(
            Duration(milliseconds: 200),
            () {
              if (mounted) this._crossScreenAnimationController.forward();
            },
          );
        }
      });
    this._jumpAnimation = Tween<double>(
      begin: 0.0,
      end: -50.0,
    ).animate(_jumpAnimationController);

    this._crossScreenAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted &&
            status == AnimationStatus.completed &&
            (currentPreset!.maxLoop == 0 || loopTime > 0)) {
          this._crossScreenAnimationController.reset();

          if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);

          int newIndex = imageIndex + 1;
          if (newIndex < imageUrls.length) {
            this.setState(() => imageIndex = newIndex);
          } else if (imageIndex > 0) {
            this.setState(() => imageIndex = 0);
          }

          Future.delayed(
            Duration(milliseconds: 1000),
            () {
              if (mounted) this.executeAnimation();
            },
          );
        } else if (mounted && currentPreset!.onFinish != null) {
          currentPreset!.onFinish!();
        }
      });
    this._crossScreenAnimation = Tween<double>(
      begin: 0.0,
      end: 600.0,
    ).animate(_crossScreenAnimationController);

    Future.delayed(Duration(milliseconds: 700), () {
      if (mounted) {
        if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);
        this.executeAnimation();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      this._crossScreenAnimationController.dispose();
    } catch (ex) {}
    try {
      this._jumpAnimationController.dispose();
    } catch (ex) {}
    super.dispose();
  }

  void executeAnimation() {
    this._crossScreenAnimationController.forward();
    Future.delayed(Duration(milliseconds: 700 + Random().nextInt(600)), () {
      if (mounted) {
        this._crossScreenAnimationController.stop(canceled: false);
        this._jumpAnimationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final animation = Container(
      transform: Matrix4.translationValues(-300, 0.0, 0.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        transform: Matrix4.translationValues(
            this._crossScreenAnimation.value, 0.0, 0.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: Offset(0, _jumpAnimation.value),
                child: Image.network(
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
          ],
        ),
      ),
    );

    return animation;
  }
}
