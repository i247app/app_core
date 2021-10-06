import 'package:app_core/header/kassets.dart';
import 'package:app_core/helper/helper.dart';
import 'package:app_core/model/kflash.dart';
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

  KFlash? flash;

  bool isFlashing = false;

  bool get isShowMessage => this.flash != null && this.isFlashing;

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

  void confettiHelperListener() async {
    if (!(KFlashHelper.flash.flashType == KFlash.TYPE_BANNER)) return;

    this.setState(() {
      this.flash = KFlashHelper.flash;
      this.isFlashing = true;
    });

    await Future.delayed(this.delayDuration);

    this.slideAnimationController.forward();

    await Future.delayed(this.displayDuration + this.animationDuration);

    setState(() => this.isFlashing = false);
  }

  @override
  Widget build(BuildContext context) {
    final blackLayer = AnimatedOpacity(
      duration: this.delayDuration,
      opacity: this.isShowMessage ? 1 : 0,
      child: Container(color: KStyles.black.withOpacity(0.5)),
    );

    Widget rawBanner;
    try {
      switch (this.flash?.mediaType) {
        case KFlash.MEDIA_TEXT:
          rawBanner = Text(
            this.flash?.media ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          );
          break;
        default:
          rawBanner = FadeInImage.assetNetwork(
            placeholder: KAssets.IMG_TRANSPARENCY,
            image: this.flash!.media!,
          );
          break;
      }
    } catch (e) {
      rawBanner = Text("# ERROR: unexpected media #");
    }

    final displayLayer = AnimatedOpacity(
      duration: this.delayDuration,
      opacity: this.isShowMessage ? 1 : 0,
      child: SlideTransition(
        position: this.slideAnimation,
        child: Center(child: rawBanner),
      ),
    );

    final body = Stack(
      fit: StackFit.expand,
      children: [
        blackLayer,
        Center(child: displayLayer),
      ],
    );

    return body;
  }
}
