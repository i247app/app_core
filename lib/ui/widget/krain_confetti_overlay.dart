import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/krain_helper.dart';
import 'package:app_core/header/kstyles.dart';

class KRainConfettiOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KRainConfettiOverlayState();
}

class _KRainConfettiOverlayState extends State<KRainConfettiOverlay>
    with TickerProviderStateMixin {
  late final AnimationController slideAnimationController;
  late final Animation<Offset> slideAnimation;

  final int generatorCount = 5;
  final Duration confettiDelay = Duration(milliseconds: 500);
  final Duration messageDisplay = Duration(milliseconds: 4500);
  final Duration messageAnimation = Duration(milliseconds: 1250);

  int get particleCount =>
      max(1, KRainHelper.confettiCount ~/ this.generatorCount);

  String get message => KRainHelper.confettiMessage;

  bool isShowMessage = false;

  @override
  void initState() {
    super.initState();

    this.slideAnimationController = AnimationController(
      duration: this.messageAnimation,
      vsync: this,
    );
    this.slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: this.slideAnimationController,
      curve: Curves.easeInCubic,
    ));

    KRainHelper.controller.addListener(confettiHelperListener);
  }

  @override
  void dispose() {
    this.slideAnimationController.dispose();
    KRainHelper.controller.removeListener(confettiHelperListener);
    super.dispose();
  }

  void confettiHelperListener() {
    if (KRainHelper.controller.state == ConfettiControllerState.playing &&
        KRainHelper.confettiMessage.isNotEmpty &&
        !this.isShowMessage) {
      Future.delayed(this.confettiDelay, () {
        this.setState(() => this.isShowMessage = true);
        slideAnimationController.forward();

        Future.delayed(this.messageDisplay, () {
          slideAnimationController.reverse();
          this.setState(() => this.isShowMessage = false);

          Future.delayed(
            this.confettiDelay,
            () => KRainHelper.confettiMessage = "",
          );
        });
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final blackBackgroundLayer = AnimatedOpacity(
      duration: this.confettiDelay,
      opacity: this.isShowMessage ? 1 : 0,
      child: Container(color: KStyles.black.withOpacity(0.5)),
    );

    final generatorListing = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<Widget>.generate(
        this.generatorCount,
        (i) => ConfettiWidget(
          confettiController: KRainHelper.controller,
          blastDirectionality: BlastDirectionality.directional,
          blastDirection: 3.0 * (pi / 2.0),
          numberOfParticles: this.particleCount,
        ),
      ),
    );

    final messageLayer = AnimatedOpacity(
      duration: this.confettiDelay,
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
        blackBackgroundLayer,
        Center(child: messageLayer),
        Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(0, -50),
            child: generatorListing,
          ),
        ),
      ],
    );

    return body;
  }
}
