import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/header/kassets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

class KEggHeroIntro extends StatefulWidget {
  final Function? onFinish;

  const KEggHeroIntro({this.onFinish});

  @override
  _KEggHeroIntroState createState() => _KEggHeroIntroState();
}

class _KEggHeroIntroState extends State<KEggHeroIntro>
    with TickerProviderStateMixin {
  Completer<AudioPlayer> cAudioPlayer = Completer();
  Completer<AudioPlayer> cBackgroundAudioPlayer = Completer();
  String? correctAudioFileUri;
  String? introAudioFileUri;

  late Animation<Offset> _bouncingAnimation, _adultBouncingAnimation;
  late Animation<double> _adultShakeAnimation,
      _shakeTheTopAnimation,
      _barrelMovingAnimation,
      _barrelHeroMovingAnimation;
  late AnimationController _adultShakeAnimationController,
      _shakeTheTopAnimationController,
      _adultBouncingAnimationController,
      _bouncingAnimationController,
      _barrelMovingAnimationController,
      _barrelHeroMovingAnimationController,
      _barrelHeroSpinAnimationController;

  final Duration adultBouncingDuration = Duration(milliseconds: 750);
  final Duration adultShakeDuration = Duration(milliseconds: 750);

  double initialPos = 1;
  double height = 0;
  double time = 0;
  double gravity = 0.0;
  double velocity = 3.5;
  Timer? _timer;
  double heroHeight = 90;
  double heroWidth = 90;
  bool showEgg = true;
  bool showAdult = false;
  int eggBreakStep = 0;
  String? heroUrl;

  int introShakeTime = 1;

  @override
  void initState() {
    super.initState();

    List<String> heroUrls = [
      "https://pix1.s3.us-west-1.amazonaws.com/hero/tofu_chan_k1.png",
      "https://pix1.s3.us-west-1.amazonaws.com/hero/duriman_k1.png",
      "https://pix1.s3.us-west-1.amazonaws.com/hero/midori_k1.png",
      "https://pix1.s3.us-west-1.amazonaws.com/hero/midori_k1.png",
      "https://pix1.s3.us-west-1.amazonaws.com/hero/midori_k1.png",
    ];
    heroUrls.shuffle();
    heroUrl = heroUrls.first;

    loadAudioAsset();

    _adultBouncingAnimationController =
        AnimationController(vsync: this, duration: adultBouncingDuration)
          ..addListener(() => setState(() {}));
    _adultBouncingAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -10.0))
        .animate(_adultBouncingAnimationController);

    this._adultShakeAnimationController = AnimationController(
      vsync: this,
      duration: adultShakeDuration,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 500), () {
            if (this.widget.onFinish != null) this.widget.onFinish!();
          });
        }
      });
    this._adultShakeAnimation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(_adultShakeAnimationController);

    _bouncingAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _bouncingAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              print("start rolling");
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
              cBackgroundAudioPlayer.future.then((ap) {
                ap.stop();
                ap.release();
              });
              try {
                final ap = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
                ap.play(correctAudioFileUri ?? "", isLocal: true);
                cAudioPlayer.complete(ap);
                this.setState(() {
                  this.eggBreakStep = 1;
                });
              } catch (e) {}
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
      duration: const Duration(milliseconds: 2750),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 1000), () {
            if (mounted) {
              setState(() {
                time = 0;
              });
            }
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
      duration: const Duration(milliseconds: 2750),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
        } else if (mounted && status == AnimationStatus.dismissed) {
          this._barrelHeroSpinAnimationController.stop();
          this._barrelHeroSpinAnimationController.reset();
          // if (this.widget.onFinish != null) this.widget.onFinish!();
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

    this._barrelMovingAnimationController.forward();
    this._barrelHeroMovingAnimationController.forward();

    Future.delayed(Duration(milliseconds: 250), () {
      try {
        final ap = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
        ap.play(introAudioFileUri ?? "", isLocal: true);
        cBackgroundAudioPlayer.complete(ap);
      } catch (e) {}
    });
  }

  @override
  void dispose() {
    cAudioPlayer.future.then((ap) {
      ap.stop();
      ap.dispose();
    });
    cBackgroundAudioPlayer.future.then((ap) {
      ap.stop();
      ap.dispose();
    });
    _adultShakeAnimationController.dispose();
    _shakeTheTopAnimationController.dispose();
    _adultBouncingAnimationController.dispose();
    _bouncingAnimationController.dispose();
    _barrelMovingAnimationController.dispose();
    _barrelHeroMovingAnimationController.dispose();
    _barrelHeroSpinAnimationController.dispose();
    super.dispose();
  }

  void loadAudioAsset() async {
    try {
      cBackgroundAudioPlayer.future
          .then((ap) => ap.setReleaseMode(ReleaseMode.LOOP));

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
    } catch (e) {}
  }

  Vector.Vector3 adultShakeTransformValue() {
    final progress = this._adultShakeAnimationController.value;
    final offset = Math.sin(progress * Math.pi * 8.0);
    return Vector.Vector3(offset * 8.0, 0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final adultView = AnimatedOpacity(
      duration: Duration(milliseconds: 0),
      opacity: this.showAdult ? 1.0 : 0.0,
      child: this.showAdult && heroUrl != null
          ? Transform.scale(
              alignment: Alignment.bottomCenter,
              scale: 0.5,
              child: KImageAnimation(
                imageUrls: [heroUrl!],
                animationType: KImageAnimationType.TINY_ZOOM_SHAKE,
                maxLoop: 1,
                onFinish: () => Future.delayed(
                  Duration(milliseconds: 1000),
                  () {
                    if (widget.onFinish != null) widget.onFinish!();
                  },
                ),
              ),
            )
          : Container(),
    );

    final eggStep0 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 0 ? 1.0 : 0.0,
      child: this.eggBreakStep == 0
          ? Transform.scale(
              alignment: Alignment.bottomCenter,
              scale: 0.5,
              child: Image.asset(
                KAssets.IMG_TAMAGO_1,
                package: 'app_core',
              ),
            )
          : Container(),
    );

    final eggStep1 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.showEgg && this.eggBreakStep == 1 ? 1.0 : 0.0,
      child: this.eggBreakStep == 1
          ? Transform.scale(
              alignment: Alignment.bottomCenter,
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
                          this.setState(() {
                            this.eggBreakStep = this.eggBreakStep + 1;
                            this.showAdult = true;
                          });
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
      opacity: this.showEgg && this.eggBreakStep == 2 ? 1.0 : 0.0,
      child: this.eggBreakStep == 2
          ? Transform.scale(
              alignment: Alignment.bottomCenter,
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
      opacity: this.showEgg && this.eggBreakStep == 3 ? 1.0 : 0.0,
      child: this.eggBreakStep == 3
          ? Transform.scale(
              alignment: Alignment.bottomCenter,
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
      opacity: this.showEgg && this.eggBreakStep == 4 ? 1.0 : 0.0,
      child: this.eggBreakStep == 4
          ? Transform.scale(
              alignment: Alignment.bottomCenter,
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
          alignment: Alignment(_barrelHeroMovingAnimation.value, 1),
          child: Transform.translate(
            offset: Offset(-heroWidth + 15, 0),
            child: Transform.translate(
              offset: _bouncingAnimation.value,
              child: Container(
                transform:
                    Matrix4.rotationZ(_shakeTheTopAnimation.value * Math.pi),
                transformAlignment: Alignment.bottomCenter,
                width: heroWidth,
                height: heroHeight,
                child: Transform.rotate(
                  angle: -this._barrelHeroSpinAnimationController.value *
                      4 *
                      Math.pi,
                  child: Image.asset(
                    KAssets.IMG_TAMAGO_CHAN,
                    width: heroWidth,
                    height: heroHeight,
                    package: 'app_core',
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(_barrelMovingAnimation.value, 1),
          child: Container(
            width: heroWidth * 2,
            height: heroHeight * 2,
            child: eggStep0,
          ),
        ),
        Align(
          alignment: Alignment(_barrelMovingAnimation.value, 1),
          child: Container(
            width: heroWidth * 2,
            height: heroHeight * 2,
            child: eggStep1,
          ),
        ),
        Align(
          alignment: Alignment(_barrelMovingAnimation.value, 1),
          child: Container(
            width: heroWidth * 2,
            height: heroHeight * 2,
            child: eggStep2,
          ),
        ),
        Align(
          alignment: Alignment(_barrelMovingAnimation.value, 1),
          child: Container(
            width: heroWidth * 2,
            height: heroHeight * 2,
            child: eggStep3,
          ),
        ),
        Align(
          alignment: Alignment(_barrelMovingAnimation.value, 1),
          child: Container(
            width: heroWidth * 2,
            height: heroHeight * 2,
            child: eggStep4,
          ),
        ),
        Align(
          alignment: Alignment(_barrelMovingAnimation.value, 1),
          child: Container(
            width: heroWidth * 2,
            height: heroHeight * 2,
            child: adultView,
          ),
        ),
      ],
    );

    return body;
  }
}
