import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kimage_animation_helper.dart';
import 'package:app_core/helper/koverlay_helper.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/ui/hero/khero_jump_multirow_game.dart';
import 'package:app_core/ui/hero/khero_jump_over_game.dart';
import 'package:app_core/ui/hero/widget/khero_game_end.dart';
import 'package:app_core/ui/hero/widget/khero_game_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/ui/hero/widget/khero_game_level.dart';
import 'package:app_core/header/kassets.dart';

class KHeroMultiGame extends StatefulWidget {
  final KHero? hero;

  const KHeroMultiGame({this.hero});

  @override
  _KHeroMultiGameState createState() => _KHeroMultiGameState();
}

class _KHeroMultiGameState extends State<KHeroMultiGame> {
  static const List<String> BG_IMAGES = [
    KAssets.IMG_BG_COUNTRYSIDE_LIGHT,
    KAssets.IMG_BG_COUNTRYSIDE_DARK,
    KAssets.IMG_BG_SPACE_LIGHT,
    KAssets.IMG_BG_SPACE_DARK,
    KAssets.IMG_BG_XMAS_LIGHT,
    KAssets.IMG_BG_XMAS_DARK,
  ];

  int? overlayID;

  int currentGame = 1;
  bool isShowShootingIntro = false;

  String get gameBackground =>
      BG_IMAGES[Math.Random().nextInt(BG_IMAGES.length)];

  void showHeroGameEndOverlay(Function() onFinish) async {
    final heroGameEnd = KHeroGameEnd(
      hero: KHero()..imageURL = KImageAnimationHelper.randomImage,
      onFinish: onFinish,
    );
    showCustomOverlay(heroGameEnd);
  }

  void showHeroGameLevelOverlay(Function() onFinish) async {
    final heroGameLevel = KHeroGameLevel(
      onFinish: onFinish,
    );
    showCustomOverlay(heroGameLevel);
  }

  void showCustomOverlay(Widget view) {
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black.withOpacity(0.6)),
        Align(alignment: Alignment.topCenter, child: view),
      ],
    );
    this.overlayID = KOverlayHelper.addOverlay(overlay);
  }

  @override
  Widget build(BuildContext context) {
    final jumpOverGame = KJumpGameScreen(
      hero: widget.hero,
      onFinishLevel: (level) {
        showHeroGameLevelOverlay(
          () {
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
          },
        );
      },
      onChangeLevel: (_) => this.setState(() {
        this.setState(() {
          this.currentGame = 2;
          this.isShowShootingIntro = true;
        });
      }),
    );

    final shootingGame = KShootingGameScreen(
      hero: widget.hero,
      onFinishLevel: (level) {
        showHeroGameLevelOverlay(
          () {
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
          },
        );
      },
      onChangeLevel: (_) => this.setState(() {
        this.setState(() {
          this.currentGame = 3;
        });
      }),
    );

    final jumpMultiRowGame = KJumpMultiRowGameScreen(
      hero: widget.hero,
      onFinishLevel: (level) {
        showHeroGameLevelOverlay(
          () {
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
          },
        );
      },
      onChangeLevel: (_) => this.setState(() {
        this.setState(() {
          this.currentGame = 4;
        });
      }),
    );

    final body = Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(this.gameBackground, package: 'app_core'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: this.isShowShootingIntro
                        ? GestureDetector(
                            onTap: () => this.setState(
                                () => this.isShowShootingIntro = false),
                            child: Container(
                              child: KGameIntro(
                                hero: widget.hero,
                                onFinish: () => this.setState(
                                    () => this.isShowShootingIntro = false),
                              ),
                            ),
                          )
                        : (currentGame == 1
                            ? jumpOverGame
                            : (currentGame == 2
                                ? shootingGame
                                : (currentGame == 3
                                    ? jumpMultiRowGame
                                    : Container()))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(body: body);
  }
}
