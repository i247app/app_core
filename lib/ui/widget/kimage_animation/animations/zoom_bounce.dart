import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/kimage_animation_parameters.dart';
import 'package:app_core/header/kassets.dart';

class ZoomBounceImage extends StatefulWidget {
  final List<String> imageUrls;
  final KImageAnimationParameters? animationPreset;

  const ZoomBounceImage(this.imageUrls, {this.animationPreset});

  @override
  _ZoomBounceImageState createState() => _ZoomBounceImageState();
}

class _ZoomBounceImageState extends State<ZoomBounceImage>
    with TickerProviderStateMixin {
  late Animation _bouncingAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _scaleAnimationController,
      _bouncingAnimationController;

  static const MAX_BOUNCE_TIME = 5;

  final Duration scaleDuration = Duration(milliseconds: 1000);
  final Duration bouncingDuration = Duration(milliseconds: 300);
  final Duration delay = Duration(milliseconds: 3000);

  KImageAnimationParameters? get currentPreset => widget.animationPreset;

  List<String> get imageUrls => widget.imageUrls;

  int bounceTime = MAX_BOUNCE_TIME;
  int imageIndex = 0;
  int loopTime = 0;

  double get heroSize => 120;

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
          this._bouncingAnimationController.forward();
        } else if (mounted && status == AnimationStatus.dismissed) {
          if (currentPreset!.maxLoop != 0 && loopTime == 0 && currentPreset!.onFinish != null) {
            currentPreset!.onFinish!();
          }
        }
      });
    _scaleAnimation = new Tween(
      begin: 1.0,
      end: 2.0,
    ).animate(new CurvedAnimation(
        parent: _scaleAnimationController, curve: Curves.bounceOut));

    _bouncingAnimationController =
        AnimationController(vsync: this, duration: bouncingDuration)
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (mounted && bounceTime > 0) {
              if (status == AnimationStatus.completed) {
                _bouncingAnimationController.reverse();
              } else if (status == AnimationStatus.dismissed) {
                _bouncingAnimationController.forward();
                this.setState(() {
                  this.bounceTime = this.bounceTime - 1;
                });
              }
            } else {
              _bouncingAnimationController.reset();
              _scaleAnimationController.reverse();
              this.bounceTime = MAX_BOUNCE_TIME;

              if (currentPreset!.maxLoop == 0 || loopTime > 0) {
                if (loopTime > 0) this.setState(() => loopTime = loopTime - 1);

                int newIndex = imageIndex + 1;
                if (newIndex < imageUrls.length) {
                  this.setState(() => imageIndex = newIndex);
                } else if (imageIndex > 0) {
                  this.setState(() => imageIndex = 0);
                }

                Future.delayed(
                  Duration(milliseconds: 700),
                  () {
                    if (mounted) {
                      this._scaleAnimationController.forward();
                    }
                  },
                );
              }
            }
          });
    _bouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -5.0))
        .animate(_bouncingAnimationController);

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
      this._bouncingAnimationController.dispose();
    } catch (ex) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Container(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: _bouncingAnimation.value,
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
              ),
            ],
          ),
        ),
      ),
    );

    return animation;
  }
}
