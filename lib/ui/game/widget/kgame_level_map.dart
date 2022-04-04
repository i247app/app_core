import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'package:app_core/ui/widget/game_levels_scrolling_map/game_levels_scrolling_map.dart';
import 'package:app_core/ui/widget/game_levels_scrolling_map/model/point_model.dart';
import 'package:app_core/ui/game/service/kgame_controller.dart';
import 'package:app_core/ui/game/service/kgame_data.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

import '../../widget/game_levels_scrolling_map/helper/utils.dart';

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

  int get currentLevel => result == null
      ? (gameData.currentLevel ?? 0)
      : ((gameData.currentLevel ?? 0) + 1);

  List<int?> get rates => [3, 2, 3, 2, 3]; // ?? gameData.rates;

  List<String> levelIconAssets = [];

  String backgroundImagePath =
      "packages/app_core/${KAssets.GAME_MAP_VERTICAL_INFINITY_02}";

  String backgroundSVGPath =
      "packages/app_core/${KAssets.GAME_MAP_VERTICAL_PATH}";

  double? backgroundImageWidth;

  double? backgroundImageHeight;

  int? pointsPerImage;

  int get imageCount => pointsPerImage != null && pointsPerImage! > 0
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
        (index) => [
          KAssets.BULLET_BALL_GREEN,
          KAssets.BULLET_BALL_BLUE,
          KAssets.BULLET_BALL_ORANGE,
          KAssets.BULLET_BALL_RED,
        ][index % 4],
      );
    }
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
    print(levelCount);
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

  bool get isReached => (level ?? 0) <= (currentLevel ?? 0);

  bool get isPassed => isReached && rate != null;

  @override
  Widget build(BuildContext context) {
    print(rate);
    return InkWell(
      child: Container(
        height: 70,
        width: 70,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: isReached ? 1 : 0.5,
                child: Image.asset(
                  KAssets.IMG_NEST,
                  fit: BoxFit.fitWidth,
                  width: 70,
                  package: 'app_core',
                ),
              ),
            ),
            if (isPassed)
              Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: isReached ? 1 : 0.3,
                  child: Image.asset(
                    KAssets.IMG_EGG,
                    width: 45,
                    height: 45,
                    package: 'app_core',
                  ),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: isReached ? 1 : 0.3,
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
            if (isPassed)
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
      onTap: () => onTap != null && (level ?? 0) <= (currentLevel ?? 0)
          ? onTap!()
          : null,
    );
  }
}
