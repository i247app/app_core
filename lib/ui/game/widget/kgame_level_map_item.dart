import 'package:app_core/app_core.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

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

  bool get isCurrent => (level ?? 0) == (currentLevel ?? 0);

  bool get isReached => (level ?? 0) <= (currentLevel ?? 0);

  bool get isPassed => isReached && rate != null && rate! != null;

  @override
  Widget build(BuildContext context) {
    final levelItem = Container(
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
          if (isReached && rate != null && rate! >= 0)
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
    );

    return InkWell(
      child: isCurrent
          ? AvatarGlow(
              glowColor: Colors.yellowAccent, endRadius: 40.0, child: levelItem)
          : levelItem,
      onTap: () => onTap != null && (level ?? 0) <= (currentLevel ?? 0)
          ? onTap!()
          : null,
    );
  }
}
