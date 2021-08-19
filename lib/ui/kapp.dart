import 'dart:async';

import 'package:app_core/header/ktheme_data.dart';
import 'package:app_core/helper/koverlay_helper.dart';
import 'package:app_core/style/ktheme.dart';
import 'package:app_core/ui/kicon/kicon_manager.dart';
import 'package:app_core/ui/widget/kembed_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KApp extends StatelessWidget {
  final Widget home;
  final TextStyle defaultTextStyle;
  final bool isEmbed;
  final String title;
  final KThemeData themeData;
  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<NavigatorObserver> navigatorObservers;
  final Map<dynamic, KIconProvider> iconSet;
  final Completer? initializer;

  const KApp({
    required this.home,
    required this.defaultTextStyle,
    required this.themeData,
    required this.navigatorKey,
    required this.scaffoldKey,
    required this.navigatorObservers,
    this.isEmbed = false,
    this.title = '',
    this.iconSet = const {},
    this.initializer,
  });

  @override
  Widget build(BuildContext context) {
    final innerApp = KTheme(
      data: this.themeData,
      child: KIconManager(
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
              theme: this.themeData.themeData,
              home: this.home,
            ),
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
      builder: (_, __) => Scaffold(
        resizeToAvoidBottomInset: false,
        key: this.scaffoldKey,
        body: innerAppWithOverlay,
      ),
    );

    return masterApp;
  }
}
