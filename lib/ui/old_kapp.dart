import 'dart:async';

import 'package:app_core/helper/koverlay_helper.dart';
import 'package:app_core/ui/kicon/kicon_manager.dart';
import 'package:app_core/ui/widget/kembed_manager.dart';
import 'package:app_core/ui/widget/kerror_view.dart';
import 'package:flutter/material.dart';

@deprecated
class OldKApp extends StatelessWidget {
  final Widget home;
  final TextStyle defaultTextStyle;
  final bool isEmbed;
  final String title;
  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<NavigatorObserver> navigatorObservers;
  final Map<dynamic, KIconProvider> iconSet;
  final Completer? initializer;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;

  const OldKApp({
    required this.home,
    required this.defaultTextStyle,
    required this.navigatorKey,
    required this.scaffoldKey,
    required this.navigatorObservers,
    this.darkTheme,
    this.theme,
    this.themeMode,
    this.isEmbed = false,
    this.title = '',
    this.iconSet = const {},
    this.initializer,
  });

  @override
  Widget build(BuildContext context) {
    final innerApp = KIconManager(
      iconSet: this.iconSet,
      child: KEmbedManager(
        isEmbed: this.isEmbed,
        child: DefaultTextStyle(
          style: this.defaultTextStyle,
          child: MaterialApp(
            title: this.title,
            navigatorKey: this.navigatorKey,
            debugShowCheckedModeBanner: false,
            navigatorObservers: this.navigatorObservers,
            theme: this.theme,
            darkTheme: this.darkTheme,
            themeMode: this.themeMode ?? ThemeMode.system,
            home: this.home,
          ),
        ),
      ),
    );

    final rawInnerAppWithOverlay = Stack(
      fit: StackFit.expand,
      children: [innerApp, KOverlayHelper.build()],
    );

    final innerAppWithOverlay = this.initializer == null
        ? rawInnerAppWithOverlay
        : FutureBuilder(
            future: this.initializer!.future,
            builder: (_, snapshot) =>
                !snapshot.hasData ? Container() : rawInnerAppWithOverlay,
          );

    final masterApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (_, __) {
        ErrorWidget.builder =
            (FlutterErrorDetails errorDetails) => KErrorView(errorDetails);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: this.scaffoldKey,
          body: innerAppWithOverlay,
        );
      },
      theme: this.theme,
      darkTheme: this.darkTheme,
      themeMode: this.themeMode ?? ThemeMode.system,
    );

    return masterApp;
  }
}
