import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class KTamagoChanJumping extends StatefulWidget {
  final Function? onFinish;
  final bool? canAdvance;

  const KTamagoChanJumping({this.onFinish, this.canAdvance});

  @override
  _KTamagoChanJumpingState createState() => _KTamagoChanJumpingState();
}

class _KTamagoChanJumpingState extends State<KTamagoChanJumping>
    with TickerProviderStateMixin {
  Completer<AudioPlayer> cAudioPlayer = Completer();
  String? correctAudioFileUri;

  late Animation _bouncingAnimation,
      _shakeTheTopLeftAnimation,
      _shakeTheTopRightAnimation;
  late AnimationController _bouncingAnimationController,
      _shakeTheTopLeftAnimationController,
      _shakeTheTopRightAnimationController;

  final List<String> heroImageUrls =
      List.generate(1, (_) => KImageAnimationHelper.randomImage);

  final Duration delay = Duration(milliseconds: 200);

  final Duration bouncingDuration = Duration(milliseconds: 250);

  int eggBreakStep = 1;

  @override
  void initState() {
    super.initState();

    loadAudioAsset();

    _bouncingAnimationController =
        AnimationController(vsync: this, duration: bouncingDuration)
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (eggBreakStep == 3) {
                this._shakeTheTopLeftAnimationController.forward();
              } else if (eggBreakStep == 4) {
                this._shakeTheTopRightAnimationController.forward();
              } else {
                _bouncingAnimationController.reverse();
                if (eggBreakStep < 4) {
                  Future.delayed(Duration(milliseconds: 1000), () {
                    if (mounted) {
                      this.setState(() {
                        this.eggBreakStep = this.eggBreakStep + 1;
                      });
                      Future.delayed(Duration(milliseconds: 100), () {
                        _bouncingAnimationController.forward();
                      });
                    }
                  });
                }
              }
            } else if (status == AnimationStatus.dismissed) {
              if ((!(widget.canAdvance ?? false) && eggBreakStep == 10) || eggBreakStep >= 4) {
                Future.delayed(Duration(milliseconds: 1000), () {
                  if (this.widget.onFinish != null) this.widget.onFinish!();
                });
              }
            }
          });
    ;
    _bouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -50.0))
        .animate(_bouncingAnimationController);

    this._shakeTheTopRightAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeTheTopRightAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _bouncingAnimationController.reverse();
          if (eggBreakStep < 4) {
            Future.delayed(Duration(milliseconds: 1000), () {
              this.setState(() {
                this.eggBreakStep = this.eggBreakStep + 1;
              });
              Future.delayed(Duration(milliseconds: 100), () {
                _bouncingAnimationController.forward();
              });
            });
          }
        }
      });
    this._shakeTheTopRightAnimation = Tween<double>(
      begin: 0,
      end: 0.06,
    ).animate(_shakeTheTopRightAnimationController);

    this._shakeTheTopLeftAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeTheTopLeftAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _bouncingAnimationController.reverse();
          if (eggBreakStep < 4) {
            Future.delayed(Duration(milliseconds: 1000), () {
              this.setState(() {
                this.eggBreakStep = this.eggBreakStep + 1;
              });
              Future.delayed(Duration(milliseconds: 100), () {
                _bouncingAnimationController.forward();
              });
            });
          }
        }
      });
    this._shakeTheTopLeftAnimation = Tween<double>(
      begin: 0,
      end: -0.06,
    ).animate(_shakeTheTopLeftAnimationController);

    Future.delayed(Duration(milliseconds: 500), () {
      try {
        final ap = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
        ap.play(correctAudioFileUri ?? "", isLocal: true);
        cAudioPlayer.complete(ap);
      } catch (e) {}
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      if (!(widget.canAdvance ?? false)) {
        this.setState(() {
          this.eggBreakStep = 10;
        });
        Future.delayed(Duration(milliseconds: 1250), () {
          if (this.widget.onFinish != null) this.widget.onFinish!();
        });
      } else {
        this.setState(() {
          this.eggBreakStep = this.eggBreakStep + 1;
        });
        Future.delayed(Duration(milliseconds: 100), () {
          _bouncingAnimationController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    this._bouncingAnimationController.dispose();
    super.dispose();
  }

  void loadAudioAsset() async {
    try {
      Directory tempDir = await getTemporaryDirectory();

      ByteData correctAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/correct.mp3");

      File correctAudioTempFile = File('${tempDir.path}/correct.mp3');
      await correctAudioTempFile
          .writeAsBytes(correctAudioFileData.buffer.asUint8List(), flush: true);

      this.setState(() {
        this.correctAudioFileUri = correctAudioTempFile.uri.toString();
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final eggStep1 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 1 ? 1.0 : 0.0,
      child: this.eggBreakStep == 1
          ? Image.asset(
              KAssets.IMG_TAMAGO_CHAN,
              package: 'app_core',
              width: 120,
            )
          : Container(),
    );

    final eggStep2 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 2 ? 1.0 : 0.0,
      child: this.eggBreakStep == 2
          ? Transform.translate(
              offset: _bouncingAnimation.value,
              child: Image.asset(
                KAssets.IMG_TAMAGO_CHAN_JUMP_UP,
                package: 'app_core',
                width: 120,
              ),
            )
          : Container(),
    );

    final eggStep3 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 3 ? 1.0 : 0.0,
      child: this.eggBreakStep == 3
          ? Container(
              transform:
                  Matrix4.rotationZ(_shakeTheTopLeftAnimation.value * Math.pi),
              transformAlignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: _bouncingAnimation.value,
                child: Image.asset(
                  KAssets.IMG_TAMAGO_CHAN_JUMP_LEFT,
                  package: 'app_core',
                  width: 120,
                ),
              ),
            )
          : Container(),
    );

    final eggStep4 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 4 ? 1.0 : 0.0,
      child: this.eggBreakStep == 4
          ? Container(
              transform:
                  Matrix4.rotationZ(_shakeTheTopRightAnimation.value * Math.pi),
              transformAlignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: _bouncingAnimation.value,
                child: Image.asset(
                  KAssets.IMG_TAMAGO_CHAN_JUMP_RIGHT,
                  package: 'app_core',
                  width: 120,
                ),
              ),
            )
          : Container(),
    );

    final eggSad = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 10 ? 1.0 : 0.0,
      child: this.eggBreakStep == 10
          ? Container(
        transform:
        Matrix4.rotationZ(_shakeTheTopRightAnimation.value * Math.pi),
        transformAlignment: Alignment.bottomCenter,
        child: Transform.translate(
          offset: _bouncingAnimation.value,
          child: Image.asset(
            KAssets.IMG_TAMAGO_CHAN_SAD,
            package: 'app_core',
            width: 120,
          ),
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
        Align(
          alignment: Alignment.center,
          child: eggSad,
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
