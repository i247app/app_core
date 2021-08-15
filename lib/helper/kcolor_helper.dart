import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

abstract class KColorHelper {
  static final Map<String, Color> nameToColorMap = {
    "BLACK": KStyles.black,
    "WHITE": KStyles.white,
  };

  static Color fromName(String name) =>
      nameToColorMap.containsKey(name.toUpperCase())
          ? nameToColorMap[name.toUpperCase()]!
          : Colors.transparent;

  static Color random() =>
      Colors.primaries[KUtil.getRandom().nextInt(Colors.primaries.length)];

  static Color fromStringHash(String z) =>
      Colors.primaries[z.hashCode % Colors.primaries.length];
}
