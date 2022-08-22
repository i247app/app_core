import 'package:app_core/app_core.dart';
import 'package:app_core/ui/game/widget/kgame_level_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'package:app_core/ui/widget/game_levels_scrolling_map/game_levels_scrolling_map.dart';
import 'package:app_core/ui/widget/game_levels_scrolling_map/model/point_model.dart';
import 'package:app_core/ui/game/service/kgame_controller.dart';
import 'package:app_core/ui/game/service/kgame_data.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

import '../../widget/game_levels_scrolling_map/helper/utils.dart';
import 'kgame_level_map_item.dart';

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

  int? overlayID;

  bool? get result => gameData.result;

  bool get canAdvance => gameData.canAdvance ?? false;

  int get currentLevel =>
      result == null || !canAdvance
          ? (gameData.currentLevel ?? 0)
          : ((gameData.currentLevel ?? 0) + 1);

  String get gameID => gameData.gameID;

  List<int?> get rates => gameData.rates;

  bool get isCountTime => gameData.isCountTime ?? false;

  List<String> levelIconAssets = [];

  String backgroundImagePath =
      "packages/app_core/${KAssets.GAME_MAP_VERTICAL_INFINITY_02}";

  String backgroundSVGPath =
      "packages/app_core/${KAssets.GAME_MAP_VERTICAL_PATH}";

  double? backgroundImageWidth;

  double? backgroundImageHeight;

  int? pointsPerImage;

  int get imageCount =>
      pointsPerImage != null && pointsPerImage! > 0
          ? (levelCount / pointsPerImage!).ceil()
          : 0;

  @override
  void initState() {
    super.initState();

    setupBackground();
    setupPoints();

    if (levelCount > 0) {
      levelIconAssets = List.generate(
        gameData.levelCount ?? 0,
            (index) =>
        [
          KAssets.BULLET_BALL_GREEN,
          KAssets.BULLET_BALL_BLUE,
          KAssets.BULLET_BALL_ORANGE,
          KAssets.BULLET_BALL_RED,
        ][index % 4],
      );
    }
  }

  @override
  void dispose() {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }

    super.dispose();
  }

  void showGameLevelDialog(int level) async {
    final gameLevelDialog = Align(
      alignment: Alignment.center,
      // child: KGameLevelDialog(
      child: KGameLevelDialog(
        gameData: gameData,
        currentLevel: level,
        onClose: () {
          if (this.overlayID != null) {
            KOverlayHelper.removeOverlay(this.overlayID!);
            this.overlayID = null;
          }
        },
        onPlay: () {
          if (this.overlayID != null) {
            KOverlayHelper.removeOverlay(this.overlayID!);
            this.overlayID = null;
          }
          if (widget.onTapLevel != null) widget.onTapLevel!(level);
        },
        game: gameID,
        isTime: isCountTime,
      ),
    );
    showCustomOverlay(gameLevelDialog);
  }

  void showCustomOverlay(Widget view) {
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black.withOpacity(0.6)),
        view,
      ],
    );
    this.overlayID = KOverlayHelper.addOverlay(overlay);
  }

  Future<String> getPointsPathFromXML() async {
    String path = "";
    XmlDocument x = await Utils.readSvg(backgroundSVGPath);
    Utils.getXmlWithClass(x, "st0").forEach((element) {
      path = element.getAttribute("points")!;
    });
    return path;
  }

  setupPoints() async {
    final svgPointsValue = await getPointsPathFromXML();
    if (KStringHelper.isExist(svgPointsValue)) {
      List<String> svgPoints = svgPointsValue.split(" ").toList();
      this.setState(() {
        pointsPerImage = svgPoints.length;
      });
    }
  }

  setupBackground() async {
    final img = await rootBundle.load(backgroundImagePath);
    final decodedImage = await decodeImageFromList(img.buffer.asUint8List());

    setState(() {
      backgroundImageWidth = double.tryParse(decodedImage.width.toString());
      backgroundImageHeight = double.tryParse(decodedImage.height.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (backgroundImageWidth == null ||
              backgroundImageHeight == null ||
              imageCount <= 0) return Container();

          return GameLevelsScrollingMap.scrollable(
            imageUrl: backgroundImagePath,
            direction: Axis.vertical,
            reverseScrolling: false,
            svgUrl: backgroundSVGPath,
            points: List.generate(
              levelCount,
                  (index) =>
                  PointModel(
                    70,
                    KGameLevelMapItem(
                      levelText: "${index + 1}",
                      levelIcon: levelIconAssets[index],
                      level: index,
                      currentLevel: currentLevel,
                      onTap: () => showGameLevelDialog(index),
                      // widget.onTapLevel != null
                      //     ? widget.onTapLevel!(index)
                      //     : null,
                      rate: rates.length > index ? rates[index] : null,
                    ),
                    isCurrent: index == currentLevel,
                  ),
            ),
            width: constraints.maxWidth,
            imageWidth: backgroundImageWidth!,
            imageHeight: backgroundImageHeight! * imageCount,
            backgroundImageWidget: Container(
              child: Column(
                children: List.generate(
                    imageCount, (index) => Image.asset(backgroundImagePath)),
              ),
            ),
            imageCount: imageCount,
            pointsPerImage: pointsPerImage,
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
