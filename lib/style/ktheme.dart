import 'package:app_core/header/ktheme_data.dart';
import 'package:flutter/material.dart';

class KTheme extends InheritedWidget {
  final Widget child;
  final KThemeData data;

  const KTheme({
    required this.child,
    required this.data,
  }) : super(child: child);

  static KTheme of(BuildContext context) {
    final KTheme? result = context.dependOnInheritedWidgetOfExactType<KTheme>();
    assert(result != null, 'No KTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(KTheme old) =>
      this.data.palettePrimary != old.data.palettePrimary;
}
