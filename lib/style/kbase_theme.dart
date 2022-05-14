import 'package:app_core/app_core.dart';
import 'package:app_core/style/kpalette.dart';
import 'package:app_core/style/kpalette_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class KBaseTheme extends InheritedWidget {
  final Widget child;
  final KPaletteGroup paletteGroup;

  ///
  /// InheritedWidget stuff
  ///
  KBaseTheme({
    required this.child,
    required this.paletteGroup,
  }) : super(child: child);

  static KBaseTheme of(BuildContext context) {
    final KBaseTheme? result =
        context.dependOnInheritedWidgetOfExactType<KBaseTheme>();
    assert(result != null, 'No KBaseTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(KBaseTheme old) =>
      paletteGroup.light.primary != old.paletteGroup.light.primary;

  Brightness get systemBrightness => SchedulerBinding.instance.window
      .platformBrightness; // MediaQuery.of(this.context).platformBrightness; //

  KPalette get activePalette =>
      isLightMode ? paletteGroup.light : paletteGroup.dark;

  bool get isLightMode => systemBrightness == Brightness.light;

  bool get isDarkMode => systemBrightness == Brightness.dark;
}
