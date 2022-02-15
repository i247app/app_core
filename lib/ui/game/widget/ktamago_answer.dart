import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class KTamagoAnswer extends StatefulWidget {
  final bool? isCorrectAnswer;

  const KTamagoAnswer({this.isCorrectAnswer});

  @override
  _KTamagoAnswerState createState() => _KTamagoAnswerState();
}

class _KTamagoAnswerState extends State<KTamagoAnswer>
    with TickerProviderStateMixin {
  late Animation _bouncingAnimation;
  late AnimationController _bouncingAnimationController;

  final Duration delay = Duration(milliseconds: 200);

  final Duration bouncingDuration = Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();

    _bouncingAnimationController =
        AnimationController(vsync: this, duration: bouncingDuration)
          ..addListener(() => setState(() {}))
          ..repeat();
    ;
    _bouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -50.0))
        .animate(_bouncingAnimationController);
  }

  @override
  void dispose() {
    this._bouncingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eggStep1 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.widget.isCorrectAnswer == null ? 1 : 0,
      child: this.widget.isCorrectAnswer == null
          ? Image.asset(
              KAssets.IMG_TAMAGO_CHAN,
              package: 'app_core',
              width: 60,
            )
          : Container(),
    );

    final eggStep2 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity:
          this.widget.isCorrectAnswer != null && this.widget.isCorrectAnswer!
              ? 1.0
              : 0.0,
      child: this.widget.isCorrectAnswer != null && this.widget.isCorrectAnswer!
          ? Image.asset(
              KAssets.IMG_TAMAGO_CHAN_JUMP_UP,
              package: 'app_core',
              width: 60,
            )
          : Container(),
    );

    final eggStep3 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity:
          this.widget.isCorrectAnswer != null && !this.widget.isCorrectAnswer!
              ? 1.0
              : 0.0,
      child:
          this.widget.isCorrectAnswer != null && !this.widget.isCorrectAnswer!
              ? Image.asset(
                  KAssets.IMG_TAMAGO_CHAN_SAD,
                  package: 'app_core',
                  width: 60,
                )
              : Container(),
    );

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: eggStep1,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: eggStep2,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: eggStep3,
        ),
      ],
    );

    final body = content;

    return Container(
      child: body,
    );
  }
}
