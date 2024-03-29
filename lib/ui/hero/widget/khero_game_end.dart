import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/ui/game/service/kgame_data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart' as Vector;

class KHeroGameEnd extends StatefulWidget {
  final KGameData? gameData;
  final KHero? hero;
  final VoidCallback? onFinish;

  const KHeroGameEnd({this.onFinish, this.hero, this.gameData});

  @override
  _KHeroGameEndState createState() => _KHeroGameEndState();
}

class _KHeroGameEndState extends State<KHeroGameEnd>
    with TickerProviderStateMixin {
  Completer<AudioPlayer> cBackgroundAudioPlayer = Completer();
  String? winAudioFileUri;

  late Animation _adultShakeAnimation, _adultBouncingAnimation;
  late AnimationController _adultShakeAnimationController,
      _adultBouncingAnimationController;

  final List<String> heroImageUrls =
      List.generate(1, (_) => KImageAnimationHelper.randomImage);

  final Duration delay = Duration(milliseconds: 200);

  final Duration adultBouncingDuration = Duration(milliseconds: 750);
  final Duration adultShakeDuration = Duration(milliseconds: 750);

  bool showAdult = true;

  int eggBreakStep = 1;

  bool get isMuted => widget.gameData?.isMuted ?? false;

  @override
  void initState() {
    super.initState();

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
        if (status == AnimationStatus.completed) {}
      });
    this._adultShakeAnimation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(_adultShakeAnimationController);

    if (!isMuted) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (!isMuted) {
          try {
            final ap = AudioPlayer();
            ap.play(DeviceFileSource(winAudioFileUri ?? ""),
                mode: PlayerMode.mediaPlayer);
            cBackgroundAudioPlayer.complete(ap);
          } catch (e) {}
        }
      });
    }
  }

  @override
  void dispose() {
    cBackgroundAudioPlayer.future.then((ap) {
      ap.stop();
      ap.dispose();
    });
    this._adultShakeAnimationController.dispose();
    this._adultBouncingAnimationController.dispose();
    super.dispose();
  }

  void loadAudioAsset() async {
    try {
      Directory tempDir = await getTemporaryDirectory();

      ByteData winAudioFileData = await rootBundle
          .load("packages/app_core/assets/audio/jingle_win.mp3");

      File winAudioTempFile = File('${tempDir.path}/jingle_win.mp3');
      await winAudioTempFile.writeAsBytes(winAudioFileData.buffer.asUint8List(),
          flush: true);

      this.setState(() {
        this.winAudioFileUri = winAudioTempFile.uri.toString();
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
    final eggStep1 = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 1 ? 1.0 : 0.0,
      child: this.eggBreakStep == 1
          ? Transform.scale(
              scale: 0.5,
              child: KImageAnimation(
                animationType: KImageAnimationType.ZOOM_SHAKE,
                imageUrls: [
                  KAssets.IMG_TAMAGO_1,
                ],
                isAssetImage: true,
                maxLoop: 1,
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
                        if (widget.hero != null &&
                            KStringHelper.isExist(widget.hero!.imageURL)) {
                          this.setState(() {
                            this.eggBreakStep = this.eggBreakStep + 1;
                          });
                        } else if (this.widget.onFinish != null)
                          this.widget.onFinish!();
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

    final heroStep = AnimatedOpacity(
      duration: Duration(milliseconds: 700),
      opacity: this.eggBreakStep == 4 ? 1.0 : 0.0,
      child: this.eggBreakStep == 4 &&
              widget.hero != null &&
              KStringHelper.isExist(widget.hero!.imageURL)
          ? Transform.scale(
              scale: 0.5,
              child: KImageAnimation(
                animationType: KImageAnimationType.ZOOM_SHAKE,
                imageUrls: [
                  widget.hero!.imageURL!,
                ],
                maxLoop: 1,
                onFinish: () {
                  if (this.widget.onFinish != null) this.widget.onFinish!();
                },
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
          child: heroStep,
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
