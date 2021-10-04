import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/kimage_animation_parameters.dart';
import 'package:app_core/header/kassets.dart';
import 'package:vector_math/vector_math_64.dart';

class CrossRightToLeftImage extends StatefulWidget {
  final List<String> imageUrls;
  final KImageAnimationParameters? animationPreset;

  const CrossRightToLeftImage(this.imageUrls, {this.animationPreset});

  @override
  _CrossRightToLeftImageState createState() => _CrossRightToLeftImageState();
}

class _CrossRightToLeftImageState extends State<CrossRightToLeftImage>
    with TickerProviderStateMixin {
  late AnimationController _crossScreenAnimationController;
  late SpringSimulation _crossScreenAnimationSimulation;

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

    this._crossScreenAnimationSimulation = SpringSimulation(
      SpringDescription(
        mass: 1,
        stiffness: 60,
        damping: 30,
      ),
      0.0, // starting point
      600.0, // ending point
      1, // velocity
    );
    this._crossScreenAnimationController =
        AnimationController(vsync: this, upperBound: 600.0)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (mounted && status == AnimationStatus.completed &&
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
                  if (mounted) {
                    this
                        ._crossScreenAnimationController
                        .animateWith(this._crossScreenAnimationSimulation);
                  }
                },
              );
            }
          });

    Future.delayed(Duration(milliseconds: 700), () {
      if (mounted) {
        if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);
        this
            ._crossScreenAnimationController
            .animateWith(this._crossScreenAnimationSimulation);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      this._crossScreenAnimationController.dispose();
    } catch (ex) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Container(
      transform: Matrix4.translationValues(300, 0.0, 0.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        transform: Matrix4.translationValues(
            -this._crossScreenAnimationController.value, 0.0, 0.0),
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
    );

    return animation;
  }
}
