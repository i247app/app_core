import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:typed_data';

import 'package:app_core/app_core.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/header/kassets.dart';
import 'package:path_provider/path_provider.dart';

class KEggHatchNewShortIntro extends StatefulWidget {
  final Function? onFinish;

  const KEggHatchNewShortIntro({this.onFinish});

  @override
  _KEggHatchNewShortIntroState createState() => _KEggHatchNewShortIntroState();
}

class _KEggHatchNewShortIntroState extends State<KEggHatchNewShortIntro>
    with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  String? correctAudioFileUri;
  String? introAudioFileUri;

  late Animation<Offset> _bouncingAnimation;
  late Animation<double> _shakeTheTopAnimation,
      _barrelMovingAnimation,
      _barrelHeroMovingAnimation;
  late AnimationController _shakeTheTopAnimationController,
      _bouncingAnimationController,
      _barrelMovingAnimationController,
      _barrelHeroMovingAnimationController,
      _barrelHeroSpinAnimationController;

  double initialPos = 1;
  double height = 0;
  double time = 0;
  double gravity = 0.0;
  double velocity = 3.5;
  Timer? _timer;
  double heroHeight = 40;
  double heroWidth = 40;
  bool isShooting = false;
  bool isPlayIntroSound = true;
  int eggBreakStep = 0;

  int introShakeTime = 2;

  @override
  void initState() {
    super.initState();

    audioPlayer.onPlayerCompletion.listen((event) {
      if (isPlayIntroSound && mounted) {
        audioPlayer.play(this.introAudioFileUri ?? "", isLocal: true);
      }
    });

    loadAudioAsset();

    _bouncingAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _bouncingAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              this._barrelHeroMovingAnimationController.reverse();
              this._barrelHeroSpinAnimationController.repeat();
            }
          });
    _bouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -10.0))
        .animate(_bouncingAnimationController);

    this._shakeTheTopAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (introShakeTime > 0 && mounted) {
          if (status == AnimationStatus.completed) {
            if (introShakeTime - 1 == 0) {
              this.setState(() {
                this.isPlayIntroSound = false;
                this.eggBreakStep = this.eggBreakStep + 1;
                Future.delayed(Duration(milliseconds: 750), () {
                  this.setState(() {
                    this.eggBreakStep = this.eggBreakStep + 1;
                  });

                  Future.delayed(Duration(milliseconds: 1000), () {
                    this.setState(() {
                      this.eggBreakStep = this.eggBreakStep + 1;
                    });

                    Future.delayed(Duration(milliseconds: 1000), () {
                      if (this.widget.onFinish != null) this.widget.onFinish!();
                    });
                  });
                });
              });
              audioPlayer.stop();
              try {
                audioPlayer.play(correctAudioFileUri ?? "", isLocal: true);
              } catch(e) {}
            }
            _shakeTheTopAnimationController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            Future.delayed(
                Duration(milliseconds: introShakeTime - 1 > 0 ? 1000 : 500),
                () {
              if (introShakeTime - 1 > 0) {
                this._shakeTheTopAnimationController.forward();
              } else {
                this._bouncingAnimationController.forward();
              }
              if (introShakeTime > 0)
                this.setState(() => introShakeTime = introShakeTime - 1);
            });
          }
        }
      });
    this._shakeTheTopAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(_shakeTheTopAnimationController);

    _barrelMovingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 1000), () {
            setState(() {
              time = 0;
            });
            // this.fire();
            this._shakeTheTopAnimationController.forward();
          });
        } else if (mounted && status == AnimationStatus.dismissed) {}
      });
    _barrelMovingAnimation = new Tween(
      begin: -2.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
        parent: _barrelMovingAnimationController, curve: Curves.linear));

    _barrelHeroMovingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
        } else if (mounted && status == AnimationStatus.dismissed) {
          this._barrelHeroSpinAnimationController.stop();
          this._barrelHeroSpinAnimationController.reset();
        }
      });
    _barrelHeroMovingAnimation = new Tween(
      begin: -2.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
        parent: _barrelHeroMovingAnimationController, curve: Curves.linear));

    _barrelHeroSpinAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (mounted && status == AnimationStatus.completed) {
            } else if (status == AnimationStatus.dismissed) {}
          });

    Future.delayed(Duration(milliseconds: 1500), () {
      this._barrelMovingAnimationController.forward();
      this._barrelHeroMovingAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _shakeTheTopAnimationController.dispose();
    _barrelMovingAnimationController.dispose();
    _barrelHeroMovingAnimationController.dispose();
    _barrelHeroSpinAnimationController.dispose();
    audioPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void loadAudioAsset() async {
    try {
      Directory tempDir = await getTemporaryDirectory();

      ByteData correctAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/correct.mp3");
      ByteData introAudioFileData =
          await rootBundle.load("packages/app_core/assets/audio/intro.mp3");

      File correctAudioTempFile = File('${tempDir.path}/correct.mp3');
      await correctAudioTempFile
          .writeAsBytes(correctAudioFileData.buffer.asUint8List(), flush: true);
      File introAudioTempFile = File('${tempDir.path}/intro.mp3');
      await introAudioTempFile
          .writeAsBytes(introAudioFileData.buffer.asUint8List(), flush: true);

      this.setState(() {
        this.correctAudioFileUri = correctAudioTempFile.uri.toString();
        this.introAudioFileUri = introAudioTempFile.uri.toString();
      });

      await audioPlayer.play(this.introAudioFileUri ?? "", isLocal: true);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final eggStep1 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 0 ? 1.0 : 0.0,
      child: this.eggBreakStep == 0
          ? Transform.scale(
              scale: 0.5,
              child: Image.asset(
                KAssets.IMG_TAMAGO_1,
                package: 'app_core',
              ),
            )
          : Container(),
    );

    final eggStep2 = AnimatedOpacity(
      duration: Duration(milliseconds: 250),
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
      duration: Duration(milliseconds: 250),
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
      duration: Duration(milliseconds: 250),
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

    final body = Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment(_barrelHeroMovingAnimation.value, 0),
          child: Transform.translate(
            offset: Offset(-heroWidth * 2 + 15, 0),
            child: Transform.translate(
              offset: _bouncingAnimation.value,
              child: Container(
                transform:
                    Matrix4.rotationZ(_shakeTheTopAnimation.value * Math.pi),
                transformAlignment: Alignment.bottomCenter,
                width: heroWidth * 2,
                height: heroHeight * 2,
                child: Transform.rotate(
                  angle: -this._barrelHeroSpinAnimationController.value *
                      4 *
                      Math.pi,
                  child: Image.asset(
                    KAssets.IMG_TAMAGO_CHAN,
                    width: heroWidth * 2,
                    height: heroHeight * 2,
                    package: 'app_core',
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(_barrelMovingAnimation.value, 0),
          child: Container(
            width: heroWidth * 4,
            height: heroHeight * 4,
            child: eggStep1,
          ),
        ),
        Align(
          alignment: Alignment(_barrelMovingAnimation.value, 0),
          child: Container(
            width: heroWidth * 4,
            height: heroHeight * 4,
            child: eggStep2,
          ),
        ),
        Align(
          alignment: Alignment(_barrelMovingAnimation.value, 0),
          child: Container(
            width: heroWidth * 4,
            height: heroHeight * 4,
            child: eggStep3,
          ),
        ),
        Align(
          alignment: Alignment(_barrelMovingAnimation.value, 0),
          child: Container(
            width: heroWidth * 4,
            height: heroHeight * 4,
            child: eggStep4,
          ),
        ),
      ],
    );

    return body;
  }
}
