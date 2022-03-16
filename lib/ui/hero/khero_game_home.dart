import 'package:app_core/app_core.dart';
import 'package:app_core/helper/koverlay_helper.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/ui/game/games/kgame_jump_over.dart';
import 'package:app_core/ui/game/games/kgame_jump_up.dart';
import 'package:app_core/ui/game/games/kgame_letter_tap.dart';
import 'package:app_core/ui/game/games/kgame_moving_tap.dart';
import 'package:app_core/ui/game/games/kgame_multi.dart';
import 'package:app_core/ui/game/games/kgame_multi_letter.dart';
import 'package:app_core/ui/game/games/kgame_shooting.dart';
import 'package:app_core/ui/game/games/kgame_tap.dart';
import 'package:app_core/ui/game/games/kgame_word.dart';
import 'package:app_core/ui/game/kgame_console.dart';
import 'package:app_core/ui/game/service/kgame_controller.dart';
import 'package:app_core/ui/hero/khero_jump_game.dart';
import 'package:app_core/ui/hero/khero_jump_multirow_game.dart';
import 'package:app_core/ui/hero/khero_jump_over_game.dart';
import 'package:app_core/ui/hero/khero_letter_tap_game.dart';
import 'package:app_core/ui/hero/khero_moving_tap_game.dart';
import 'package:app_core/ui/hero/khero_multi_game.dart';
import 'package:app_core/ui/hero/khero_shooting_game.dart';
import 'package:app_core/ui/hero/khero_speech_letter_tap_game.dart';
import 'package:app_core/ui/hero/khero_tap_game.dart';
import 'package:app_core/ui/hero/khero_training.dart';
import 'package:app_core/ui/hero/widget/kegg_hatch_new_short_intro.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';

import '../../header/kassets.dart';
import 'khero_speech_tap_game.dart';

class KHeroGameHome extends StatefulWidget {
  final KHero? hero;

  const KHeroGameHome({
    this.hero,
  });

  @override
  _KHeroGameHomeState createState() => _KHeroGameHomeState();
}

class _KHeroGameHomeState extends State<KHeroGameHome> {
  int? overlayID;
  bool isShowIntro = true;

  @override
  void initState() {
    super.initState();
  }

  void onTraining(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => KHeroTraining(hero: hero)));
  }

  void onPlaySpeechTapGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => KHeroSpeechTapGame(hero: hero)));
  }

  void onPlayTapGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => KHeroTapGame(hero: hero)));
  }

  void onPlayMovingTapGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => KHeroMovingTapGame(hero: hero)));
  }

  void onPlaySpeechLetterTapGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => KHeroSpeechLetterTapGame(hero: hero)));
  }

  void onPlayLetterTapGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => KHeroLetterTapGame(hero: hero)));
  }

  void onPlayJumpOverGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => KHeroJumpOverGame(hero: hero)));
  }

  void onPlayJumpGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => KHeroJumpGame(hero: hero)));
  }

  void onPlayJumpMultiRowGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (ctx) => KHeroJumpGame(hero: hero)));
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => KHeroJumpMultiRowGame(hero: hero)));
  }

  void onPlayShootingGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => KHeroShootingGame(hero: hero)));
  }

  void onPlayMultiGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => KHeroMultiGame(hero: hero)));
  }

  void showCustomOverlay(Widget view) {
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Theme.of(context).backgroundColor.withOpacity(1)),
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
    final gameListing = ListView(
      shrinkWrap: true,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onTraining(null),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: FittedBox(
                        child: Text(
                          "🕹",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Training"),
                  ),
                ],
              ),
              SizedBox(
                width: 64,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => KGameConsole(
                        KGameController(
                          gameID: KGameShooting.GAME_ID,
                          gameName: KGameShooting.GAME_NAME,
                          levelCount: 4,
                          currentLevel: 0,
                        ),
                      ),
                    )),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: Image.asset(
                      KAssets.IMG_CANNON_BARREL,
                      height: 60,
                      width: 60,
                      package: 'app_core',
                    ),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Shooting"),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => KGameConsole(
                        KGameController(
                          gameID: KGameTap.GAME_ID,
                          gameName: KGameTap.GAME_NAME,
                          levelCount: 4,
                          currentLevel: 0,
                          isCountTime: true,
                        ),
                      ),
                    )),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: FittedBox(
                        child: Text(
                          "👾",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Tap"),
                  ),
                ],
              ),
              SizedBox(
                width: 64,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => KGameConsole(
                        KGameController(
                          gameID: KGameMovingTap.GAME_ID,
                          gameName: KGameMovingTap.GAME_NAME,
                          levelCount: 4,
                          currentLevel: 0,
                          isCountTime: true,
                        ),
                      ),
                    )),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: FittedBox(
                        child: Text(
                          "👾",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Moving"),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => KGameConsole(
                        KGameController(
                          gameID: KGameJumpUp.GAME_ID,
                          gameName: KGameJumpUp.GAME_NAME,
                          levelCount: 4,
                          currentLevel: 0,
                        ),
                      ),
                    )),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: FittedBox(
                        child: Text(
                          "👾",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Jump Up"),
                  ),
                ],
              ),
              SizedBox(
                width: 64,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => KGameConsole(
                        KGameController(
                          gameID: KGameJumpOver.GAME_ID,
                          gameName: KGameJumpOver.GAME_NAME,
                          levelCount: 4,
                          currentLevel: 0,
                        ),
                      ),
                    )),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: FittedBox(
                        child: Text(
                          "👾",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Jump Over"),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => KGameConsole(
                        KGameController(
                          gameID: KGameMultiLetter.GAME_ID,
                          gameAppID: KGameMultiLetter.GAME_APP_ID,
                          gameName: KGameMultiLetter.GAME_NAME,
                          levelCount: 4,
                          currentLevel: 0,
                          answerType: 'letter',
                          isSpeechGame: true,
                          // isCountTime: true,
                        ),
                      ),
                    )),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: FittedBox(
                        child: Text(
                          "🔈",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Letter"),
                  ),
                ],
              ),
              SizedBox(
                width: 64,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => KGameConsole(
                        KGameController(
                          gameID: KGameMulti.GAME_ID,
                          gameAppID: KGameMulti.GAME_APP_ID,
                          gameName: KGameMulti.GAME_NAME,
                          levelCount: 4,
                          currentLevel: 0,
                          isSpeechGame: true,
                          // isCountTime: true,
                        ),
                      ),
                    )),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: FittedBox(
                        child: Text(
                          "🔈",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Number"),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 32,
        ),
        if (!KHostConfig.isReleaseMode)
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => KGameConsole(
                              KGameController(
                                gameID: KGameWord.GAME_ID,
                                gameAppID: KGameWord.GAME_APP_ID,
                                gameName: KGameWord.GAME_NAME,
                                levelCount: 4,
                                currentLevel: 0,
                                answerType: 'word',
                                // isCountTime: true,
                              ),
                            ),
                          )),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        primary: Colors.transparent,
                        onPrimary: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: FittedBox(
                          child: Text(
                            "👾",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    FittedBox(
                      child: Text("Word"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        // Text(
        //   "Speech Games",
        //   style: TextStyle(
        //     fontWeight: FontWeight.w600,
        //     fontSize: 18,
        //   ),
        // ),
        // SizedBox(height: 5),
        // Container(
        //   child: GridView.count(
        //     shrinkWrap: true,
        //     childAspectRatio: 1,
        //     crossAxisCount: 4,
        //     crossAxisSpacing: 10,
        //     physics: NeverScrollableScrollPhysics(),
        //     children: [
        //       Column(
        //         mainAxisSize: MainAxisSize.min,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           ElevatedButton(
        //             onPressed: () =>
        //                 Navigator.of(context).push(MaterialPageRoute(
        //               builder: (ctx) => KGameConsole(
        //                 KGameController(
        //                   gameID: KGameMultiLetter.GAME_ID,
        //                   gameAppID: KGameMultiLetter.GAME_APP_ID,
        //                   gameName: KGameMultiLetter.GAME_NAME,
        //                   levelCount: 4,
        //                   currentLevel: 0,
        //                   answerType: 'letter',
        //                   isSpeechGame: true,
        //                   // isCountTime: true,
        //                 ),
        //               ),
        //             )),
        //             style: KStyles.squaredButton(
        //               Theme.of(context).colorScheme.primary,
        //               textColor: Colors.white,
        //             ),
        //             child: Text("👾"),
        //           ),
        //           SizedBox(width: 5),
        //           FittedBox(
        //             child: Text("Letter"),
        //           ),
        //         ],
        //       ),
        //       Column(
        //         mainAxisSize: MainAxisSize.min,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           ElevatedButton(
        //             onPressed: () =>
        //                 Navigator.of(context).push(MaterialPageRoute(
        //               builder: (ctx) => KGameConsole(
        //                 KGameController(
        //                   gameID: KGameMulti.GAME_ID,
        //                   gameAppID: KGameMulti.GAME_APP_ID,
        //                   gameName: KGameMulti.GAME_NAME,
        //                   levelCount: 4,
        //                   currentLevel: 0,
        //                   isSpeechGame: true,
        //                   // isCountTime: true,
        //                 ),
        //               ),
        //             )),
        //             style: KStyles.squaredButton(
        //               Theme.of(context).colorScheme.primary,
        //               textColor: Colors.white,
        //             ),
        //             child: Text("👾"),
        //           ),
        //           SizedBox(width: 5),
        //           FittedBox(
        //             child: Text("Number"),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(height: 25),
        // Text(
        //   "Other Games",
        //   style: TextStyle(
        //     fontWeight: FontWeight.w600,
        //     fontSize: 18,
        //   ),
        // ),
        // SizedBox(height: 5),
        // Container(
        //   child: GridView.count(
        //     shrinkWrap: true,
        //     childAspectRatio: 1,
        //     crossAxisCount: 4,
        //     crossAxisSpacing: 10,
        //     physics: NeverScrollableScrollPhysics(),
        //     children: [
        //       // Column(
        //       //   mainAxisSize: MainAxisSize.min,
        //       //   crossAxisAlignment: CrossAxisAlignment.center,
        //       //   mainAxisAlignment: MainAxisAlignment.center,
        //       //   children: [
        //       //     ElevatedButton(
        //       //       onPressed: () =>
        //       //           Navigator.of(context).push(MaterialPageRoute(
        //       //         builder: (ctx) => KGameRoom(
        //       //           KGameController(
        //       //             gameID: KGameSpeechLetterTap.GAME_ID,
        //       //             gameAppID: KGameSpeechLetterTap.GAME_APP_ID,
        //       //             gameName: KGameSpeechLetterTap.GAME_NAME,
        //       //             levelCount: 4,
        //       //             currentLevel: 0,
        //       //             answerType: 'letter',
        //       //             isSpeechGame: true,
        //       //             // isCountTime: true,
        //       //           ),
        //       //         ),
        //       //       )),
        //       //       style: KStyles.squaredButton(
        //       //         Theme.of(context).colorScheme.primary,
        //       //         textColor: Colors.white,
        //       //       ),
        //       //       child: Text("🔈"),
        //       //     ),
        //       //     SizedBox(width: 5),
        //       //     FittedBox(
        //       //       child: Text("Speech Letter"),
        //       //     ),
        //       //   ],
        //       // ),
        //       // Column(
        //       //   mainAxisSize: MainAxisSize.min,
        //       //   crossAxisAlignment: CrossAxisAlignment.center,
        //       //   mainAxisAlignment: MainAxisAlignment.center,
        //       //   children: [
        //       //     ElevatedButton(
        //       //       onPressed: () =>
        //       //           Navigator.of(context).push(MaterialPageRoute(
        //       //         builder: (ctx) => KGameRoom(
        //       //           KGameController(
        //       //             gameID: KGameSpeechTap.GAME_ID,
        //       //             // gameAppID: KGameSpeechTap.GAME_APP_ID,
        //       //             gameName: KGameSpeechTap.GAME_NAME,
        //       //             levelCount: 4,
        //       //             currentLevel: 0,
        //       //             isSpeechGame: true,
        //       //             // isCountTime: true,
        //       //           ),
        //       //         ),
        //       //       )),
        //       //       style: KStyles.squaredButton(
        //       //         Theme.of(context).colorScheme.primary,
        //       //         textColor: Colors.white,
        //       //       ),
        //       //       child: Text("🔈"),
        //       //     ),
        //       //     SizedBox(width: 5),
        //       //     FittedBox(
        //       //       child: Text("Speech Math"),
        //       //     ),
        //       //   ],
        //       // ),
        //       // Column(
        //       //   mainAxisSize: MainAxisSize.min,
        //       //   crossAxisAlignment: CrossAxisAlignment.center,
        //       //   mainAxisAlignment: MainAxisAlignment.center,
        //       //   children: [
        //       //     ElevatedButton(
        //       //       onPressed: () =>
        //       //           Navigator.of(context).push(MaterialPageRoute(
        //       //         builder: (ctx) => KGameRoom(
        //       //           KGameController(
        //       //             gameID: KGameSpeechMovingTap.GAME_ID,
        //       //             gameAppID: KGameSpeechMovingTap.GAME_APP_ID,
        //       //             gameName: KGameSpeechMovingTap.GAME_NAME,
        //       //             levelCount: 4,
        //       //             currentLevel: 0,
        //       //             isSpeechGame: true,
        //       //             // isCountTime: true,
        //       //           ),
        //       //         ),
        //       //       )),
        //       //       style: KStyles.squaredButton(
        //       //         Theme.of(context).colorScheme.primary,
        //       //         textColor: Colors.white,
        //       //       ),
        //       //       child: Text("🔈"),
        //       //     ),
        //       //     SizedBox(width: 5),
        //       //     FittedBox(
        //       //       child: Text("Speech Math Moving"),
        //       //     ),
        //       //   ],
        //       // ),
        //       Column(
        //         mainAxisSize: MainAxisSize.min,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           ElevatedButton(
        //             onPressed: () =>
        //                 Navigator.of(context).push(MaterialPageRoute(
        //               builder: (ctx) => KGameConsole(
        //                 KGameController(
        //                   gameID: KGameWord.GAME_ID,
        //                   gameName: KGameWord.GAME_NAME,
        //                   levelCount: 4,
        //                   currentLevel: 0,
        //                   answerType: 'letter',
        //                   isCountTime: true,
        //                 ),
        //               ),
        //             )),
        //             style: KStyles.squaredButton(
        //               Theme.of(context).colorScheme.primary,
        //               textColor: Colors.white,
        //             ),
        //             child: Text("👾"),
        //           ),
        //           SizedBox(width: 5),
        //           FittedBox(
        //             child: Text("Word"),
        //           ),
        //         ],
        //       ),
        //       Column(
        //         mainAxisSize: MainAxisSize.min,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           ElevatedButton(
        //             onPressed: () =>
        //                 Navigator.of(context).push(MaterialPageRoute(
        //               builder: (ctx) => KGameConsole(
        //                 KGameController(
        //                   gameID: KGameTap.GAME_ID,
        //                   gameName: KGameTap.GAME_NAME,
        //                   levelCount: 4,
        //                   currentLevel: 0,
        //                   isCountTime: true,
        //                 ),
        //               ),
        //             )),
        //             style: KStyles.squaredButton(
        //               Theme.of(context).colorScheme.primary,
        //               textColor: Colors.white,
        //             ),
        //             child: Text("👾"),
        //           ),
        //           SizedBox(width: 5),
        //           FittedBox(
        //             child: Text("Tap"),
        //           ),
        //         ],
        //       ),
        //       Column(
        //         mainAxisSize: MainAxisSize.min,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           ElevatedButton(
        //             onPressed: () =>
        //                 Navigator.of(context).push(MaterialPageRoute(
        //               builder: (ctx) => KGameConsole(
        //                 KGameController(
        //                   gameID: KGameMovingTap.GAME_ID,
        //                   gameName: KGameMovingTap.GAME_NAME,
        //                   levelCount: 4,
        //                   currentLevel: 0,
        //                   isCountTime: true,
        //                 ),
        //               ),
        //             )),
        //             style: KStyles.squaredButton(
        //               Theme.of(context).colorScheme.primary,
        //               textColor: Colors.white,
        //             ),
        //             child: Text("👾"),
        //           ),
        //           SizedBox(width: 5),
        //           FittedBox(
        //             child: Text("Moving Tap"),
        //           ),
        //         ],
        //       ),
        //       Column(
        //         mainAxisSize: MainAxisSize.min,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           ElevatedButton(
        //             onPressed: () =>
        //                 Navigator.of(context).push(MaterialPageRoute(
        //               builder: (ctx) => KGameConsole(
        //                 KGameController(
        //                   gameID: KGameJumpUp.GAME_ID,
        //                   gameName: KGameJumpUp.GAME_NAME,
        //                   levelCount: 4,
        //                   currentLevel: 0,
        //                 ),
        //               ),
        //             )),
        //             style: KStyles.squaredButton(
        //               Theme.of(context).colorScheme.primary,
        //               textColor: Colors.white,
        //             ),
        //             child: Text("🕹️"),
        //           ),
        //           SizedBox(width: 5),
        //           FittedBox(
        //             child: Text("Jump Up"),
        //           ),
        //         ],
        //       ),
        //       Column(
        //         mainAxisSize: MainAxisSize.min,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           ElevatedButton(
        //             onPressed: () =>
        //                 Navigator.of(context).push(MaterialPageRoute(
        //               builder: (ctx) => KGameConsole(
        //                 KGameController(
        //                   gameID: KGameJumpOver.GAME_ID,
        //                   gameName: KGameJumpOver.GAME_NAME,
        //                   levelCount: 4,
        //                   currentLevel: 0,
        //                 ),
        //               ),
        //             )),
        //             style: KStyles.squaredButton(
        //               Theme.of(context).colorScheme.primary,
        //               textColor: Colors.white,
        //             ),
        //             child: Text("👾"),
        //           ),
        //           SizedBox(width: 5),
        //           FittedBox(
        //             child: Text("Jump Over"),
        //           ),
        //         ],
        //       ),
        //       Column(
        //         mainAxisSize: MainAxisSize.min,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           ElevatedButton(
        //             onPressed: () =>
        //                 Navigator.of(context).push(MaterialPageRoute(
        //               builder: (ctx) => KGameConsole(
        //                 KGameController(
        //                   gameID: KGameLetterTap.GAME_ID,
        //                   gameName: KGameLetterTap.GAME_NAME,
        //                   levelCount: 4,
        //                   currentLevel: 0,
        //                   answerType: 'letter',
        //                   isCountTime: true,
        //                 ),
        //               ),
        //             )),
        //             style: KStyles.squaredButton(
        //               Theme.of(context).colorScheme.primary,
        //               textColor: Colors.white,
        //             ),
        //             child: Text("👾"),
        //           ),
        //           SizedBox(width: 5),
        //           FittedBox(
        //             child: Text("English Tap"),
        //           ),
        //         ],
        //       ),
        //       // Column(
        //       //   mainAxisSize: MainAxisSize.min,
        //       //   crossAxisAlignment: CrossAxisAlignment.center,
        //       //   mainAxisAlignment: MainAxisAlignment.center,
        //       //   children: [
        //       //     ElevatedButton(
        //       //       onPressed: () =>
        //       //           Navigator.of(context).push(MaterialPageRoute(
        //       //             builder: (ctx) => KGameRoom(
        //       //               KGameController(
        //       //                 gameID: KGameJumpMultiRow.GAME_ID,
        //       //                 gameName: KGameJumpMultiRow.GAME_NAME,
        //       //                 levelCount: 4,
        //       //                 currentLevel: 0,
        //       //               ),
        //       //             ),
        //       //           )),
        //       //       style: KStyles.squaredButton(
        //       //         Theme.of(context).colorScheme.primary,
        //       //         textColor: Colors.white,
        //       //       ),
        //       //       child: Text("🏆"),
        //       //     ),
        //       //     SizedBox(width: 5),
        //       //     FittedBox(
        //       //       child: Text("Jump Multi Row"),
        //       //     ),
        //       //   ],
        //       // ),
        //       Column(
        //         mainAxisSize: MainAxisSize.min,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           ElevatedButton(
        //             onPressed: () =>
        //                 Navigator.of(context).push(MaterialPageRoute(
        //               builder: (ctx) => KGameConsole(
        //                 KGameController(
        //                   gameID: KGameShooting.GAME_ID,
        //                   gameName: KGameShooting.GAME_NAME,
        //                   levelCount: 4,
        //                   currentLevel: 0,
        //                 ),
        //               ),
        //             )),
        //             style: ElevatedButton.styleFrom(
        //               elevation: 0,
        //               padding:
        //                   EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        //               primary: Colors.transparent,
        //               onPrimary: Colors.transparent,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(4),
        //                 side: BorderSide(color: Colors.transparent),
        //               ),
        //             ),
        //             child: Image.asset(
        //               KAssets.IMG_CANNON_BARREL,
        //               height: 30,
        //               width: 30,
        //               package: 'app_core',
        //             ),
        //           ),
        //           SizedBox(width: 5),
        //           FittedBox(
        //             child: Text("Shooting"),
        //           ),
        //         ],
        //       ),
        //       // Column(
        //       //   mainAxisSize: MainAxisSize.min,
        //       //   crossAxisAlignment: CrossAxisAlignment.center,
        //       //   mainAxisAlignment: MainAxisAlignment.center,
        //       //   children: [
        //       //     ElevatedButton(
        //       //       onPressed: () => onPlayMultiGame(null),
        //       //       style: KStyles.squaredButton(
        //       //         Theme.of(context).colorScheme.primary,
        //       //         textColor: Colors.white,
        //       //       ),
        //       //       child: Text("🎮"),
        //       //     ),
        //       //     SizedBox(width: 5),
        //       //     FittedBox(
        //       //       child: Text("Multi Game"),
        //       //     ),
        //       //   ],
        //       // ),
        //     ],
        //   ),
        // ),
      ],
    );

    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          // heroDetail,
          Center(
            child: Center(
              child: Text(
                "Games",
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Expanded(child: gameListing),
        ],
      ),
    );

    final body = Stack(
      fit: StackFit.expand,
      children: [
        if (!this.isShowIntro) content,
        if (this.isShowIntro) ...[
          Container(color: Theme.of(context).backgroundColor.withOpacity(1)),
          KEggHatchNewShortIntro(
              onFinish: () => setState(() => this.isShowIntro = false)),
          GestureDetector(
              onTap: () => setState(() => this.isShowIntro = false)),
        ],
      ],
    );

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: body),
    );
  }
}
