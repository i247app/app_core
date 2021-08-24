import 'package:app_core/header/kpalette.dart';
import 'package:flutter/material.dart';

class KTheme extends InheritedWidget {
  final Widget child;
  final KPalette palette;

  const KTheme({
    required this.child,
    required this.palette,
  }) : super(child: child);

  static KTheme of(BuildContext context) {
    final KTheme? result = context.dependOnInheritedWidgetOfExactType<KTheme>();
    assert(result != null, 'No KTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(KTheme old) =>
      this.palette.palettePrimary != old.palette.palettePrimary;
}
