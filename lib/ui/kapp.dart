import 'package:app_core/helper/kglobals.dart' as global;
import 'package:app_core/style/ktheme.dart';
import 'package:app_core/style/kstyle_manager.dart';
import 'package:app_core/ui/widget/kembed_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KApp extends StatelessWidget {
  final Widget body;
  final TextStyle defaultTextStyle;
  final bool isEmbed;
  final String title;
  final KTheme kTheme;
  final GlobalKey<NavigatorState>? navigatorKey;
  final List<NavigatorObserver>? navigatorObservers;

  static KTheme get defaultTheme => KTheme(
        palettePrimary: Color(0xff79AF2C),
        paletteSecondary: Color(0xffFBA922),
        paletteSupport: Color(0xffA3D0C1),
        paletteButtonText: Colors.white,
        palette4: Color(0xffFF8370),
        palette5: Color(0xffCEB27C),
        yes: Color(0xff79AF2C),
        no: Colors.red,
        themeData: ThemeData(
          primarySwatch: Colors.lightGreen,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        child: Container(),
      );

  const KApp({
    required this.body,
    required this.defaultTextStyle,
    required this.kTheme,
    this.isEmbed = false,
    this.title = '',
    this.navigatorKey,
    this.navigatorObservers,
  });

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: this.title,
      navigatorKey: this.navigatorKey ?? global.kNavigatorKey,
      debugShowCheckedModeBanner: false,
      navigatorObservers: this.navigatorObservers ?? [],
      theme: this.kTheme.themeData,
      home: this.body,
    );

    return KStyleManager(
      theme: this.kTheme,
      child: KEmbedManager(
        isEmbed: this.isEmbed,
        child: DefaultTextStyle(
          style: this.defaultTextStyle,
          child: app,
        ),
      ),
    );
  }
}
