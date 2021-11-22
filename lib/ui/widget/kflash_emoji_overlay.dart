import 'dart:math';

import 'package:app_core/app_core.dart';
import 'package:app_core/model/kflash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/kflash_helper.dart';
import 'package:app_core/value/kstyles.dart';

class KFlashEmojiOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KFlashEmojiOverlayState();
}

class _KFlashEmojiOverlayState extends State<KFlashEmojiOverlay>
    with TickerProviderStateMixin {
  late final AnimationController slideAnimationController;
  late final Animation<double> slideAnimation;

  late List<List<double>> emojiSeeds;

  final Duration animDuration = Duration(milliseconds: 5000);

  int get particleCount => 32;

  List<String> emojis = ["😎"];

  @override
  void initState() {
    super.initState();

    resetEmojiSeeds();

    this.slideAnimationController = AnimationController(
      duration: this.animDuration,
      vsync: this,
    );
    this.slideAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: this.slideAnimationController,
      curve: Curves.linear,
    ))
      ..addListener(() => setState(() {}));
    KFlashHelper.flashController.addListener(confettiHelperListener);
  }

  @override
  void dispose() {
    this.slideAnimationController.dispose();
    KFlashHelper.flashController.removeListener(confettiHelperListener);
    super.dispose();
  }

  void resetEmojiSeeds() {
    final min = 0.3;
    final max = 1;
    final rnd = Random();
    this.emojiSeeds = List.generate(
      this.particleCount,
      (i) => [
        rnd.nextDouble(),
        rnd.nextDouble() * (max - min) + min,
        rnd.nextDouble(),
      ],
    );
  }

  void confettiHelperListener() {
    if (!(KFlashHelper.flash.flashType == KFlash.TYPE_RAIN &&
        KFlashHelper.flash.mediaType == KFlash.MEDIA_EMOJI)) return;

    if (this.slideAnimationController.status == AnimationStatus.dismissed) {
      resetEmojiSeeds();
      this.setState(
          () => this.emojis = [KFlashHelper.flashController.value.media!]);
      this
          .slideAnimationController
          .forward()
          .whenComplete(() => this.slideAnimationController.reset());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final sideToSideMovement = 32;

    final body = Stack(
      children: List.generate(
        this.particleCount,
        (i) => Positioned(
          left: size.width * this.emojiSeeds[i][0] +
              sideToSideMovement *
                  cos(this.slideAnimationController.value *
                      this.emojiSeeds[i][1] *
                      2 *
                      pi) -
              sideToSideMovement / 2,
          top: (size.height + 100) *
                  this.slideAnimationController.value /
                  this.emojiSeeds[i][1] -
              100,
          child: Text(
            this.emojis[(this.emojiSeeds[i][2] * this.emojis.length).round() %
                this.emojis.length],
            style: KStyles.largeXLText,
          ),
        ),
      ),
    );

    return body;
  }
}
