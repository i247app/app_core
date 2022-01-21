import 'package:app_core/ui/hero/khero_jump_game.dart';
import 'package:app_core/ui/hero/khero_letter_tap_game.dart';
import 'package:app_core/ui/hero/khero_moving_tap_game.dart';
import 'package:app_core/ui/hero/khero_speech_letter_tap_game.dart';
import 'package:app_core/ui/hero/khero_tap_game.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:app_core/helper/koverlay_helper.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/ui/hero/khero_jump_multirow_game.dart';
import 'package:app_core/ui/hero/khero_jump_over_game.dart';
import 'package:app_core/ui/hero/khero_multi_game.dart';
import 'package:flutter/material.dart';
import 'package:app_core/ui/hero/khero_shooting_game.dart';
import 'package:app_core/ui/hero/khero_training.dart';

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
        Text(
          "Newbie",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 5),
        Container(
          child: GridView.count(
            shrinkWrap: true,
            childAspectRatio: 1,
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlaySpeechLetterTapGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("🔈"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Speech Letter"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlaySpeechTapGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("🔈"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Speech Math"),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 25),
        Text(
          "Novice",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 5),
        Container(
          child: GridView.count(
            shrinkWrap: true,
            childAspectRatio: 1,
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onTraining(widget.hero),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("💪"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Training"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayJumpOverGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("👾️"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Jump Over"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayTapGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("👾️"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Tap"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayMovingTapGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("👾️"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Moving Tap"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayLetterTapGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("👾️️"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("English Tap"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayJumpGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("🕹️"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Jump Up"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayJumpMultiRowGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("🏆"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Jump Multi Row"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayShootingGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("🔫"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Shooting"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayMultiGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("🎮"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Multi Game"),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 25),
        Text(
          "Genius",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 5),
        Container(
          child: GridView.count(
            shrinkWrap: true,
            childAspectRatio: 1,
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onTraining(widget.hero),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("💪"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Training"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayJumpOverGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("👾️"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Jump Over"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayTapGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("👾️"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Tap"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayMovingTapGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("👾️"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Moving Tap"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayLetterTapGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("👾️️"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("English Tap"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayJumpGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("🕹️"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Jump Up"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayJumpMultiRowGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("🏆"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Jump Multi Row"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayShootingGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("🔫"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Shooting"),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onPlayMultiGame(null),
                    style: KStyles.squaredButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: Text("🎮"),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Multi Game"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          // heroDetail,
          Expanded(child: gameListing),
        ],
      ),
    );

    final body = Stack(
      fit: StackFit.expand,
      children: [
        content,
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text("My Games")),
      body: SafeArea(child: body),
    );
  }
}
