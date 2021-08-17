import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/kflash_helper.dart';
import 'package:app_core/header/kstyles.dart';

class KFlashBannerOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KFlashBannerOverlayState();
}

class _KFlashBannerOverlayState extends State<KFlashBannerOverlay>
    with TickerProviderStateMixin {
  late final AnimationController slideAnimationController;
  late final Animation<Offset> slideAnimation;

  final Duration delayDuration = Duration(milliseconds: 500);
  final Duration displayDuration = Duration(milliseconds: 4500);
  final Duration animationDuration = Duration(milliseconds: 1250);

  String get message => KFlashHelper.flashController.value.media ?? "";

  bool isShowMessage = false;

  @override
  void initState() {
    super.initState();

    this.slideAnimationController = AnimationController(
      duration: this.animationDuration,
      vsync: this,
    );
    this.slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: this.slideAnimationController,
      curve: Curves.easeInCubic,
    ));

    KFlashHelper.flashController.addListener(confettiHelperListener);
  }

  @override
  void dispose() {
    this.slideAnimationController.dispose();
    KFlashHelper.flashController.removeListener(confettiHelperListener);
    super.dispose();
  }

  void confettiHelperListener() {
    this.setState(() => this.isShowMessage = true);
    Future.delayed(
      this.displayDuration,
      () => setState(() => this.isShowMessage = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final animatedLayer = AnimatedOpacity(
      duration: this.delayDuration,
      opacity: this.isShowMessage ? 1 : 0,
      child: Container(color: KStyles.black.withOpacity(0.5)),
    );

    final messageLayer = AnimatedOpacity(
      duration: this.delayDuration,
      opacity: this.isShowMessage ? 1 : 0,
      child: SlideTransition(
        position: this.slideAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              this.message,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );

    final body = Stack(
      fit: StackFit.expand,
      children: [
        animatedLayer,
        Center(child: messageLayer),
      ],
    );

    return body;
  }
}
