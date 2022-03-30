import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'package:app_core/ui/widget/game_levels_scrolling_map/game_levels_scrolling_map.dart';
import 'package:app_core/ui/widget/game_levels_scrolling_map/model/point_model.dart';
import 'package:app_core/ui/game/service/kgame_controller.dart';
import 'package:app_core/ui/game/service/kgame_data.dart';

class KGameLevelMap extends StatefulWidget {
  final KGameController controller;
  final Function(int? level)? onTapLevel;
  final bool isEmbedded;

  const KGameLevelMap(this.controller,
      {this.onTapLevel, this.isEmbedded = false});

  @override
  _KGameLevelMapState createState() => _KGameLevelMapState();
}

class _KGameLevelMapState extends State<KGameLevelMap> {
  KGameData get gameData => widget.controller.value;

  int get levelCount => gameData.levelCount ?? 0;

  bool? get result => gameData.result;

  int get currentLevel => result == null ? (gameData.currentLevel ?? 0) : ((gameData.currentLevel ?? 0) + 1);

  List<int?> get rates => gameData.rates;

  List<String> levelIconAssets = [];

  @override
  void initState() {
    super.initState();

    if (levelCount > 0) {
      levelIconAssets = List.generate(
        gameData.levelCount ?? 0,
        (index) => [
          KAssets.BULLET_BALL_GREEN,
          KAssets.BULLET_BALL_BLUE,
          KAssets.BULLET_BALL_ORANGE,
          KAssets.BULLET_BALL_RED,
        ][index % 4],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return GameLevelsScrollingMap(
            imageUrl: "packages/app_core/${KAssets.GAME_MAP_VERTICAL}",
            // direction: Axis.vertical,
            // reverseScrolling: true,
            svgUrl: "packages/app_core/${KAssets.GAME_MAP_VERTICAL_PATH}",
            points: List.generate(
              levelCount,
              (index) => PointModel(
                70,
                KGameLevelMapItem(
                  levelText: "${index + 1}",
                  levelIcon: levelIconAssets[index],
                  level: index,
                  currentLevel: currentLevel,
                  onTap: () => widget.onTapLevel != null
                      ? widget.onTapLevel!(index)
                      : null,
                  rate: rates.length > index ? rates[index] : null,
                ),
                isCurrent: index == currentLevel,
              ),
            ),
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          );
        },
      ),
    );

    return widget.isEmbedded
        ? body
        : Scaffold(
            appBar: AppBar(),
            body: SafeArea(child: body),
          );
  }
}

class KGameLevelMapItem extends StatelessWidget {
  final String? levelText;
  final int? level;
  final int? currentLevel;
  final String? levelIcon;
  final Function? onTap;
  final int? rate;

  KGameLevelMapItem({
    this.levelText,
    this.levelIcon,
    this.level,
    this.currentLevel,
    this.onTap,
    this.rate,
  });

  @override
  Widget build(BuildContext context) {
    print(rate);
    return InkWell(
      child: Container(
        height: (level ?? 0) <= (currentLevel ?? 0) && rate != null ? 83 : 70,
        width: 70,
        child: Stack(
          children: [
            if (levelIcon != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: (level ?? 0) <= (currentLevel ?? 0) ? 1 : 0.3,
                  child: Image.asset(
                    levelIcon!,
                    fit: BoxFit.fitWidth,
                    width: 70,
                    package: 'app_core',
                  ),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: (level ?? 0) <= (currentLevel ?? 0) ? 1 : 0.3,
                child: Container(
                  width: 70,
                  height: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        "${levelText ?? ""}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.black,
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        "${levelText ?? ""}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if ((level ?? 0) <= (currentLevel ?? 0) && rate != null)
              Align(
                alignment: Alignment.topCenter,
                child: FittedBox(
                  child: Row(
                    children: [
                      ...List.generate(
                        rate!,
                        (index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                      ...List.generate(
                        3 - rate!,
                        (index) => Icon(
                          Icons.star_border,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      onTap: () => onTap != null && (level ?? 0) <= (currentLevel ?? 0) ? onTap!() : null,
    );
  }
}
