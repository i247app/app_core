import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/kimage_animation_parameters.dart';
import 'package:app_core/header/kassets.dart';
import 'package:vector_math/vector_math_64.dart';

class DropBounceImage extends StatefulWidget {
  final List<String> imageUrls;
  final KImageAnimationParameters? animationPreset;

  const DropBounceImage(this.imageUrls, {this.animationPreset});

  @override
  _DropBounceImageState createState() => _DropBounceImageState();
}

class _DropBounceImageState extends State<DropBounceImage>
    with TickerProviderStateMixin {
  late AnimationController _dropBounceAnimationController;
  late SpringSimulation _dropBounceAnimationSimulation;

  KImageAnimationParameters? get currentPreset => widget.animationPreset;

  List<String> get imageUrls => widget.imageUrls;

  int imageIndex = 0;
  int loopTime = 0;

  bool isShowImage = false;

  double get heroSize => 120;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.loopTime = currentPreset?.maxLoop ?? 0;
    print(this.loopTime);
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
            if (mounted &&
                status == AnimationStatus.completed &&
                (currentPreset?.maxLoop == 0 || loopTime > 0)) {
              if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);

              Future.delayed(
                Duration(milliseconds: 500),
                () {
                  if (mounted) {
                    this.setState(() => this.isShowImage = false);
                    this._dropBounceAnimationController.reset();

                    int newIndex = imageIndex + 1;
                    if (newIndex < imageUrls.length) {
                      this.setState(() => imageIndex = newIndex);
                    } else if (imageIndex > 0) {
                      this.setState(() => imageIndex = 0);
                    }
                  }
                },
              );

              Future.delayed(
                Duration(milliseconds: 1000),
                () {
                  if (mounted) {
                    this.setState(() => this.isShowImage = true);
                    this
                        ._dropBounceAnimationController
                        .animateWith(this._dropBounceAnimationSimulation);
                  }
                },
              );
            } else if (mounted && currentPreset!.onFinish != null) {
              currentPreset!.onFinish!();
            }
          });

    Future.delayed(Duration(milliseconds: 1000), () {
      if (mounted) {
        if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);
        this.setState(() => this.isShowImage = true);
        this
            ._dropBounceAnimationController
            .animateWith(this._dropBounceAnimationSimulation);
      }
    });
  }

  @override
  void dispose() {
    try {
      this._dropBounceAnimationController.dispose();
    } catch (ex) {}
    super.dispose();
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
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
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
            ],
          ),
        ),
      ),
    );

    return animation;
  }
}
