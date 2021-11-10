import 'dart:async';
import 'dart:math' as Math;

import 'package:app_core/header/kassets.dart';
import 'package:app_core/ui/widget/kimage_animation/kimage_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KEggHatchShortIntro extends StatefulWidget {
  final VoidCallback? onFinish;

  const KEggHatchShortIntro({this.onFinish});

  @override
  _KEggHatchShortIntroState createState() => _KEggHatchShortIntroState();
}

class _KEggHatchShortIntroState extends State<KEggHatchShortIntro>
    with TickerProviderStateMixin {
  int eggBreakStep = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eggStep1 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 1 ? 1.0 : 0.0,
      child: this.eggBreakStep == 1
          ? Transform.scale(
              scale: 0.5,
              child: KImageAnimation(
                animationType: KImageAnimationType.SHAKE_THE_TOP,
                imageUrls: [
                  KAssets.IMG_TAMAGO_1,
                ],
                isAssetImage: true,
                maxLoop: 2,
                onFinish: () {
                  Future.delayed(Duration(milliseconds: 750), () {
                    this.setState(() {
                      this.eggBreakStep = this.eggBreakStep + 1;
                    });

                    Future.delayed(Duration(milliseconds: 1000), () {
                      this.setState(() {
                        this.eggBreakStep = this.eggBreakStep + 1;
                      });

                      Future.delayed(Duration(milliseconds: 1000), () {
                        this.setState(() {
                          this.eggBreakStep = this.eggBreakStep + 1;
                        });

                        Future.delayed(Duration(milliseconds: 1500), () {
                          if (this.widget.onFinish != null)
                            this.widget.onFinish!();
                        });
                      });
                    });
                  });
                },
              ),
            )
          : Container(),
    );

    final eggStep2 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 2 ? 1.0 : 0.0,
      child: this.eggBreakStep == 2
          ? Transform.scale(
              scale: 0.5,
              child: Image.asset(
                KAssets.IMG_TAMAGO_2,
                package: 'app_core',
              ),
            )
          : Container(),
    );

    final eggStep3 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 3 ? 1.0 : 0.0,
      child: this.eggBreakStep == 3
          ? Transform.scale(
              scale: 0.5,
              child: Image.asset(
                KAssets.IMG_TAMAGO_3,
                package: 'app_core',
              ),
            )
          : Container(),
    );

    final eggStep4 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 4 ? 1.0 : 0.0,
      child: this.eggBreakStep == 4
          ? Transform.scale(
              scale: 0.5,
              child: Image.asset(
                KAssets.IMG_TAMAGO_4,
                package: 'app_core',
              ),
            )
          : Container(),
    );

    final content = Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: eggStep1,
        ),
        Align(
          alignment: Alignment.center,
          child: eggStep2,
        ),
        Align(
          alignment: Alignment.center,
          child: eggStep3,
        ),
        Align(
          alignment: Alignment.center,
          child: eggStep4,
        ),
      ],
    );

    final body = content;

    return Stack(
      children: [
        body,
      ],
    );
  }
}
