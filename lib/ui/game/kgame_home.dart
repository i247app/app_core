import 'package:app_core/app_core.dart';
import 'package:app_core/ui/game/games/kgame_multi_number.dart';
import 'package:app_core/ui/game/games/kgame_tap.dart';
import 'package:app_core/ui/game/kgame_console.dart';
import 'package:app_core/ui/game/service/kgame_controller.dart';
import 'package:app_core/ui/hero/widget/kegg_hatch_new_short_intro.dart';
import 'package:flutter/material.dart';

import '../game/widget/kgame_setting_dialog.dart';

class KGameHome extends StatefulWidget {
  @override
  _KGameHomeState createState() => _KGameHomeState();
}

class _KGameHomeState extends State<KGameHome> {
  int? overlayID;
  bool isShowIntro = true;

  @override
  void initState() {
    super.initState();
  }

  void showGameSettingDialog() async {
    final gameLevelDialog = Align(
      alignment: Alignment.center,
      // child: KGameLevelDialog(
      child: KGameSettingDialog(
        onClose: () {
          if (this.overlayID != null) {
            KOverlayHelper.removeOverlay(this.overlayID!);
            this.overlayID = null;
          }
        },
      ),
    );
    showCustomOverlay(gameLevelDialog);
  }

  void showCustomOverlay(Widget view) {
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        Container(
            color: Theme.of(context).colorScheme.background.withOpacity(0)),
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
    final double ICON_WIDTH = 90;
    final double ICON_HEIGHT = 90;

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
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => KGameConsole(
                        KGameController(
                          gameID: KGameMultiNumber.GAME_ID,
                          gameAppID: KGameMultiNumber.GAME_APP_ID,
                          gameName: KGameMultiNumber.GAME_NAME,
                          currentLevel: 0,
                          answerType: 'number',
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
                      width: ICON_WIDTH,
                      height: ICON_HEIGHT,
                      child: Image.asset(
                        KAssets.IMG_GAME_TAP_MOVING,
                        fit: BoxFit.contain,
                        package: 'app_core',
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Count"),
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
                          gameID: KGameTap.GAME_ID,
                          gameName: KGameTap.GAME_NAME,
                          currentLevel: 0,
                          isCountTime: true,
                        ),
                      ),
                    )),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: SizedBox(
                      width: ICON_WIDTH,
                      height: ICON_HEIGHT,
                      child: Image.asset(
                        KAssets.IMG_GAME_TAP,
                        fit: BoxFit.contain,
                        package: 'app_core',
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    child: Text("Math+"),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 32,
        ),
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
          // Container(color: Theme.of(context).backgroundColor.withOpacity(1)),
          KEggHatchNewShortIntro(
              onFinish: () => setState(() => this.isShowIntro = false)),
          GestureDetector(
              onTap: () => setState(() => this.isShowIntro = false)),
        ],
      ],
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!KHostConfig.isReleaseMode)
            IconButton(
              onPressed: () => showGameSettingDialog(),
              icon: Icon(
                Icons.settings,
              ),
            ),
        ],
      ),
      body: SafeArea(child: body),
    );
  }
}
