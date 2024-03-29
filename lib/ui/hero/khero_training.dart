import 'dart:async';
import 'dart:io';

import 'package:app_core/model/khero.dart';
import 'package:app_core/ui/hero/widget/kegg_hero_intro.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_core/header/kassets.dart';
import 'package:path_provider/path_provider.dart';

class KHeroTraining extends StatefulWidget {
  final KHero? hero;

  const KHeroTraining({this.hero});

  @override
  _KHeroTrainingState createState() => _KHeroTrainingState();
}

class _KHeroTrainingState extends State<KHeroTraining>
    with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  String? correctAudioFileUri;

  late Animation<double> _scaleAnimation;
  late AnimationController _scaleAnimationController;

  double heroY = 0;
  double initialPos = 0;
  double height = 0;
  double time = 0;
  double gravity = -4;
  double velocity = 1.8;
  Timer? _timer;
  bool isStart = false;
  bool isPlaySound = false;
  bool isShowIntro = true;

  int points = 0;
  bool resetPos = false;
  double currentTarget = -1.3;
  double topTarget = -1.4;
  double bottomTarget = -0.7;
  bool isShowPlusPoint = false;
  DateTime? lastGetPointTime;
  double heroWidth = 90;
  double heroHeight = 90;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadAudioAsset();

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          this.setState(() {
            isShowPlusPoint = false;
          });
          // Future.delayed(Duration(milliseconds: 500), () {
          //   if (!this._scaleAnimationController.isAnimating) this._scaleAnimationController.reset();
          // });
        } else if (mounted && status == AnimationStatus.dismissed) {}
      });
    _scaleAnimation = new Tween(
      begin: 1.0,
      end: 2.0,
    ).animate(new CurvedAnimation(
        parent: _scaleAnimationController, curve: Curves.bounceOut));

    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (isStart) {
        height = (gravity - points * 0.2) * time * time + velocity * time;
        final pos = initialPos - height;

        setState(() {
          if (pos <= -2.4) {
          } else if (pos <= 0) {
            heroY = pos;
          } else
            heroY = 0;
        });

        if (isReachTarget() &&
            (lastGetPointTime == null ||
                lastGetPointTime!.difference(DateTime.now()).inMilliseconds <
                    -1000)) {
          this.setState(() {
            isShowPlusPoint = true;
          });
          if (!this._scaleAnimationController.isAnimating) {
            if (!isPlaySound) {
              this.setState(() {
                this.isPlaySound = true;
              });
              playSound(true);
            }
            this._scaleAnimationController.reset();
            this._scaleAnimationController.forward();
          }
          setState(() {
            // resetPos = true;
            lastGetPointTime = DateTime.now();
            points = points + 1;
          });
        }

        // if (heroY == 0 && resetPos) {
        //   setState(() {
        //     resetPos = false;
        //   });
        // }

        time += 0.01;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleAnimationController.dispose();
    // TODO: implement dispose
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

  void playSound(bool isTrueAnswer) async {
    try {
      if (isTrueAnswer) {
        await audioPlayer.play(DeviceFileSource(correctAudioFileUri ?? ""),
            mode: PlayerMode.lowLatency);
      } else {}
    } catch (e) {}
    this.setState(() {
      this.isPlaySound = false;
    });
  }

  bool isReachTarget() {
    double topTargetValue =
        -this.topTarget * MediaQuery.of(context).size.height;
    double bottomTargetValue =
        -this.bottomTarget * MediaQuery.of(context).size.height;
    double heroPosValue = -heroY * MediaQuery.of(context).size.height;

    return heroPosValue >= bottomTargetValue + 128 &&
        heroPosValue <= topTargetValue;
  }

  void jump() {
    setState(() {
      if (!isStart) {
        isStart = true;
      }
      time = 0;
      initialPos = heroY;
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = this.isShowIntro
        ? Stack(
            fit: StackFit.expand,
            children: [
              if (this.isShowIntro) ...[
                KEggHeroIntro(
                    onFinish: () => setState(() => this.isShowIntro = false)),
                GestureDetector(
                    onTap: () => setState(() => this.isShowIntro = false)),
              ],
            ],
          )
        : Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              child: Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 5, right: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 80,
                            height: 80,
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 15),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  KAssets.IMG_TARGET_ORANGE,
                                  package: 'app_core',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Text(
                              "${this.points}",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0, 1 + topTarget),
                          child: Container(
                            width: ((bottomTarget - topTarget) / 2) *
                                MediaQuery.of(context).size.height,
                            height: ((bottomTarget - topTarget) / 2) *
                                MediaQuery.of(context).size.height,
                            color: Theme.of(context).backgroundColor,
                            child: Transform.scale(
                              scale: 1.0,
                              child: Image.asset(
                                isReachTarget()
                                    ? KAssets.IMG_TARGET_GOLD
                                    : KAssets.IMG_TARGET_GREEN,
                                width: ((bottomTarget - topTarget) / 2) *
                                    MediaQuery.of(context).size.height,
                                height: ((bottomTarget - topTarget) / 2) *
                                    MediaQuery.of(context).size.height,
                                package: 'app_core',
                              ),
                            ),
                          ),
                          // child: SizedBox(
                          //   width: ((bottomTarget - topTarget) / 2) *
                          //       MediaQuery.of(context).size.height,
                          //   height: ((bottomTarget - topTarget) / 2) *
                          //       MediaQuery.of(context).size.height,
                          //   child: DecoratedBox(
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.rectangle,
                          //       color: Theme.of(context).backgroundColor,
                          //       borderRadius: BorderRadius.only(
                          //         topLeft: Radius.circular((((bottomTarget - topTarget)/2)*MediaQuery.of(context).size.height)/2),
                          //         topRight: Radius.circular((((bottomTarget - topTarget)/2)*MediaQuery.of(context).size.height)/2),
                          //         bottomLeft: Radius.circular((((bottomTarget - topTarget)/2)*MediaQuery.of(context).size.height)/2),
                          //         bottomRight: Radius.circular((((bottomTarget - topTarget)/2)*MediaQuery.of(context).size.height)/2),
                          //       ),
                          //       border: Border.all(
                          //         color: Colors.green,
                          //         width: 20,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Transform.translate(
                            offset: Offset(0, 80),
                            child: Transform.translate(
                              offset:
                                  Offset(0, -80 * (_scaleAnimation.value - 1)),
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: isShowPlusPoint ? 1 : 0,
                                child: Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: heroWidth,
                            height: heroHeight,
                            alignment: Alignment(0, 1 + heroY),
                            child: Image.network(
                              widget.hero?.imageURL ?? "",
                              width: heroWidth,
                              height: heroHeight,
                              errorBuilder: (context, error, stack) =>
                                  Image.asset(
                                KAssets.IMG_TAMAGO_CHAN,
                                width: heroWidth,
                                height: heroHeight,
                                package: 'app_core',
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: jump,
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  child: Image.asset(
                    KAssets.IMG_BUTTON_GREEN,
                    width: 80.0,
                    height: 80.0,
                    package: 'app_core',
                  ),
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              SizedBox(height: 36),
            ],
          );

    return Scaffold(
      // appBar: AppBar(title: Text("Hero Training")),
      body: SafeArea(
        child: body,
      ),
    );
  }
}
