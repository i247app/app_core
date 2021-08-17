import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/kflash_helper.dart';

class KFlashConfettiOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KFlashConfettiOverlayState();
}

class _KFlashConfettiOverlayState extends State<KFlashConfettiOverlay>
    with TickerProviderStateMixin {
  final int generatorCount = 5;
  final Duration confettiDelay = Duration(milliseconds: 500);

  int get particleCount =>
      max(1, KFlashHelper.confettiCount ~/ this.generatorCount);

  @override
  void initState() {
    super.initState();

    KFlashHelper.confettiController.addListener(confettiHelperListener);
  }

  @override
  void dispose() {
    KFlashHelper.confettiController.removeListener(confettiHelperListener);
    super.dispose();
  }

  void confettiHelperListener() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final generatorListing = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<Widget>.generate(
        this.generatorCount,
        (i) => ConfettiWidget(
          confettiController: KFlashHelper.confettiController,
          blastDirectionality: BlastDirectionality.directional,
          blastDirection: 3.0 * (pi / 2.0),
          numberOfParticles: this.particleCount,
        ),
      ),
    );

    final body = Stack(
      fit: StackFit.expand,
      children: [
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
