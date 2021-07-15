import 'dart:math' as Math;

import 'package:flutter/widgets.dart';

abstract class AppCoreTabletDetector {
  static bool isTablet(MediaQueryData query) {
    final size = query.size;
    final diagonal =
        Math.sqrt((size.width * size.width) + (size.height * size.height));

    final isTablet = diagonal > 1100.0;
    return isTablet;
  }
}
