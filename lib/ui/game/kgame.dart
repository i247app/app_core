import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kanswer.dart';
import 'package:app_core/model/kgame.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/model/kquestion.dart';
import 'package:app_core/model/kgame_score.dart';
import 'package:app_core/ui/hero/widget/kegg_hero_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_count_down_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_end.dart';
import 'package:app_core/ui/hero/widget/khero_game_highscore_dialog.dart';
import 'package:app_core/ui/hero/widget/khero_game_pause_dialog.dart';
import 'package:app_core/ui/hero/widget/ktamago_chan_jumping.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class KHeroJumpGame extends StatefulWidget {
  final KHero? hero;

  const KHeroJumpGame({this.hero});

  @override
  _KHeroJumpGameState createState() => _KHeroJumpGameState();
}

class _KHeroJumpGameState extends State<KHeroJumpGame> {
  static const GAME_NAME = "jump_game";
  static const GAME_ID = "530";

  static const List<String> BACKGROUND_IMAGES = [
    KAssets.IMG_BG_COUNTRYSIDE_LIGHT,
    KAssets.IMG_BG_COUNTRYSIDE_DARK,
    KAssets.IMG_BG_SPACE_LIGHT,
    KAssets.IMG_BG_SPACE_DARK,
    KAssets.IMG_BG_XMAS_LIGHT,
    KAssets.IMG_BG_XMAS_DARK,
  ];
  late final String gameBackground = (BACKGROUND_IMAGES..shuffle()).first;

  int? overlayID;

  int totalLevel = 4;
  int currentLevel = 0;
  bool isShowEndLevel = false;
  bool isShowIntro = true;

  KGameScore? score;
  KGame? game = null;

  List<KQuestion> get questions => game?.qnas?[0].questions ?? [];
  bool isLoaded = false;
  bool isCached = false;

  @override
  void initState() {
    super.initState();

    cacheHeroImages();
    loadGame();
  }

  void cacheHeroImages() async {
    setState(() {
      this.isCached = false;
    });
    try {
      for (int i = 0; i < KImageAnimationHelper.animationImages.length; i++) {
        await Future.wait(KImageAnimationHelper.animationImages
            .map((image) => DefaultCacheManager().getSingleFile(image)));
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      this.isCached = true;
    });
  }

  loadGame() async {
    try {
      setState(() {
        this.isLoaded = false;
      });

      final response = await KServerHandler.getGames(
          gameID: GAME_ID, level: currentLevel.toString());

      if (response.isSuccess &&
          response.games != null &&
          response.games!.length > 0) {
        setState(() {
          this.game = response.games![0];
          this.isLoaded = true;
        });
      } else {
        KSnackBarHelper.error("Can not get game data");
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
  }

  void showHeroGameEndOverlay(Function() onFinish) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameEnd = KHeroGameEnd(
      hero: KHero()..imageURL = KImageAnimationHelper.randomImage,
      onFinish: onFinish,
    );
    showCustomOverlay(heroGameEnd);
  }

  void showHeroGameLevelOverlay(Function() onFinish, {bool? canAdvance}) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameLevel =
        KTamagoChanJumping(onFinish: onFinish, canAdvance: canAdvance);
    showCustomOverlay(heroGameLevel);
  }

  void showHeroGameHighscoreOverlay(Function() onClose) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameHighScore = Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: KGameHighscoreDialog(
            onClose: onClose,
            game: GAME_ID,
            score: this.score,
            ascendingSort: false,
            currentLevel: currentLevel,
          ),
        ),
      ],
    );
    showCustomOverlay(heroGameHighScore);
  }

  void showCustomOverlay(Widget view) {
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black.withOpacity(0.6)),
        Align(
          alignment: Alignment.topCenter,
          child: view,
        ),
      ],
    );
    this.overlayID = KOverlayHelper.addOverlay(overlay);
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  BACKGROUND_IMAGES[currentLevel],
                  package: 'app_core',
                ),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
            child: !isLoaded || !isCached || game == null
                ? Container()
                : (this.isShowIntro
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          if (this.isShowIntro) ...[
                            KEggHeroIntro(
                                onFinish: () =>
                                    setState(() => this.isShowIntro = false)),
                            GestureDetector(
                                onTap: () =>
                                    setState(() => this.isShowIntro = false)),
                          ],
                        ],
                      )
                    : SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Expanded(
                            //   child: _KJumpGameScreen(
                            //     hero: widget.hero,
                            //     totalLevel: totalLevel,
                            //     isShowEndLevel: isShowEndLevel,
                            //     questions: questions,
                            //     level: currentLevel,
                            //     isLoaded: isLoaded,
                            //     onFinishLevel: (level, score, canAdvance) {
                            //       if (!canAdvance) {
                            //         this.showHeroGameLevelOverlay(() {
                            //           this.setState(() {
                            //             this.isShowEndLevel = false;
                            //           });
                            //           if (this.overlayID != null) {
                            //             KOverlayHelper.removeOverlay(
                            //                 this.overlayID!);
                            //             this.overlayID = null;
                            //           }
                            //         }, canAdvance: canAdvance);
                            //         return;
                            //       }
                            //
                            //       this.setState(() {
                            //         this.score = KGameScore()
                            //           ..game = GAME_ID
                            //           ..avatarURL = KSessionData.me!.avatarURL
                            //           ..kunm = KSessionData.me!.kunm
                            //           ..level = "$level"
                            //           ..score = "$score";
                            //       });
                            //       if (level < totalLevel) {
                            //         this.showHeroGameLevelOverlay(() {
                            //           if (this.overlayID != null) {
                            //             KOverlayHelper.removeOverlay(
                            //                 this.overlayID!);
                            //             this.overlayID = null;
                            //           }
                            //           this.showHeroGameHighscoreOverlay(() {
                            //             this.setState(() {
                            //               this.isShowEndLevel = false;
                            //             });
                            //             if (this.overlayID != null) {
                            //               KOverlayHelper.removeOverlay(
                            //                   this.overlayID!);
                            //               this.overlayID = null;
                            //             }
                            //           });
                            //         }, canAdvance: canAdvance);
                            //       } else {
                            //         this.showHeroGameEndOverlay(
                            //           () {
                            //             if (this.overlayID != null) {
                            //               KOverlayHelper.removeOverlay(
                            //                   this.overlayID!);
                            //               this.overlayID = null;
                            //             }
                            //             this.showHeroGameHighscoreOverlay(() {
                            //               this.setState(() {
                            //                 this.isShowEndLevel = false;
                            //               });
                            //               if (this.overlayID != null) {
                            //                 KOverlayHelper.removeOverlay(
                            //                     this.overlayID!);
                            //                 this.overlayID = null;
                            //               }
                            //             });
                            //           },
                            //         );
                            //       }
                            //     },
                            //     onChangeLevel: (level) {
                            //       this.setState(
                            //         () {
                            //           this.currentLevel = level;
                            //         },
                            //       );
                            //       this.loadGame();
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      )),
          ),
        ),
      ],
    );

    return Scaffold(
      // appBar: AppBar(title: Text("Play game")),
      body: body,
    );
  }
}
