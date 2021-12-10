import 'package:app_core/app_core.dart';
import 'package:app_core/style/kpalette.dart';
import 'package:flutter/cupertino.dart';

class KPaletteGroup {
  final KPalette light;
  final KPalette dark;

  const KPaletteGroup({
    required this.light,
    required this.dark,
  });

  KPalette getPaletteByBrightness(Brightness brightness) =>
      brightness == Brightness.light ? light : dark;
}
