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
  late final List<List<double>> emojis;

  final Duration animDuration = Duration(milliseconds: 5000);

  int get particleCount => 32;

  String emoji = "🤤";

  @override
  void initState() {
    super.initState();

    double min = 0.3;
    double max = 1;
    final rnd = new Random();

    this.emojis = List.generate(
      this.particleCount,
      (i) => [
        KUtil.getRandom().nextDouble(),
        rnd.nextDouble() * (max - min) + min,
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
      this.setState(() {
        this.emoji = KConfettiHelper.emoji;
      });
      this.slideAnimationController.forward().whenComplete(() {
        this.slideAnimationController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final body = Stack(
      children: List.generate(
        this.particleCount,
        (i) => Positioned(
          left: size.width * this.emojis[i].first +
              32 *
                  cos(this.slideAnimationController.value *
                      this.emojis[i].last *
                      2 *
                      pi) -
              16,
          top: (size.height + 100) *
                  this.slideAnimationController.value /
                  this.emojis[i].last -
              100,
          child: Text(emoji, style: KStyles.largeXLText),
        ),
      ),
    );

    return body;
  }
}
