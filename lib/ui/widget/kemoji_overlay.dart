import 'dart:math';

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/kconfetti_helper.dart';
import 'package:app_core/header/kstyles.dart';

class KEmojiOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KEmojiOverlayState();
}

class _KEmojiOverlayState extends State<KEmojiOverlay>
    with TickerProviderStateMixin {
  late final AnimationController slideAnimationController;
  late final Animation<double> slideAnimation;
  late final List<List<double>> emojiSeeds;

  final Duration animDuration = Duration(milliseconds: 5000);

  int get particleCount => 32;

  List<String> emojis = ["😎"];

  @override
  void initState() {
    super.initState();

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
    KConfettiHelper.emojiController.addListener(confettiHelperListener);
  }

  @override
  void dispose() {
    this.slideAnimationController.dispose();
    KConfettiHelper.emojiController.removeListener(confettiHelperListener);
    super.dispose();
  }

  void confettiHelperListener() {
    if (this.slideAnimationController.status == AnimationStatus.dismissed) {
      this.setState(() => this.emojis = KConfettiHelper.displayEmojis);
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
            this.emojis[(this.emojiSeeds[i][2] % this.emojis.length).round()],
            style: KStyles.largeXLText,
          ),
        ),
      ),
    );

    return body;
  }
}
