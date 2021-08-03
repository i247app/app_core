import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KTheme extends InheritedWidget {
  final Widget child;

  const KTheme({
    required this.child,
    required this.palettePrimary,
    required this.paletteSecondary,
    required this.paletteSupport,
    required this.paletteButtonText,
    required this.palette4,
    required this.palette5,
    required this.yes,
    required this.no,
    required this.themeData,
  }) : super(child: child);

  static KTheme of(BuildContext context) {
    final KTheme? result = context.dependOnInheritedWidgetOfExactType<KTheme>();
    assert(result != null, 'No KTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(KTheme old) =>
      this.palettePrimary != old.palettePrimary;

  /* Base Colors */
  static const Color white = Colors.white; //Color(0xfffafafa);
  static const Color black = Color(0xff111111);
  static const Color green = Colors.green; //Color(0xfffafafa);
  static const Color extraExtraLightGrey = Color(0xffefefef);
  static const Color extraLightGrey = Color(0xffdedede);
  static const Color chatGrey = Color(0xff8b8b8b);
  static const Color lightGrey = Color(0xffbbbbbb);
  static const Color superLightGrey = Color(0xffdddddd);
  static const Color grey = Color(0xff888888);
  static const Color darkGrey = Color(0xff666666);
  static const Color extraDarkGrey = Color(0xff333333);
  static const Color blueFaded = Color(0xffcce5ff);
  static const Color lightBlue = Color(0xff0088dd);
  static const Color blue = Colors.blue;

  /* Base Spacings */
  static const double spacingSmall = 4;
  static const double spacingNormal = 8;
  static const double spacingLarge = 12;

  /* Base Dimensions */
  static const double fontSizeSmall = 14;
  static const double fontSizeNormal = 16;
  static const double fontSizeLarge = 18;
  static const double fontSizeXL = 24;
  static const double fontSizeXXL = 28;

  /* Base Fonts */
  final String fontComfortaa = "Comfortaa";
  final String fontQuicksand = "Quicksand";

  final Color palettePrimary;
  final Color paletteSecondary;
  final Color paletteSupport;
  final Color paletteButtonText;
  final Color palette4;
  final Color palette5;
  final Color yes;
  final Color no;
  final ThemeData themeData;

  Color get colorButton => this.palettePrimary;

  Color get colorButtonText => this.paletteButtonText;

  Color get colorIcon => this.palettePrimary;

  Color get colorBGYes => this.palettePrimary;

  Color get colorSuccess => this.palettePrimary;

  Color get colorWarning => Colors.orange;

  Color get colorBGNo => Colors.red;

  Color get colorError => Colors.red;

  Color get colorRequiredField => Colors.red;

  Color get colorPrimary => this.palettePrimary;

  Color get colorSecondary => this.paletteSecondary;

  Color get colorFormBorder => Color(0xffdddddd);

  Color get colorDivider => extraLightGrey;

  double get headerFontSize => fontSizeLarge;

  /// SystemUiOverlayStyle
  SystemUiOverlayStyle get systemStyle => SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      );

  /// Preset InputDecoration
  InputDecoration get inputDecoration => InputDecoration(
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(60)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );

  /// Preset ButtonStyle
  ButtonStyle roundedButton(Color primary, {Color? textColor}) =>
      ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        textStyle: roundedActionBtnText,
        primary: primary,
        onPrimary: textColor ?? roundedActionBtnText.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
          side: BorderSide(color: Colors.transparent),
        ),
      );

  ButtonStyle squaredButton(Color primary, {Color? textColor}) =>
      ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        textStyle: squaredActionBtnText,
        primary: primary,
        onPrimary: textColor ?? squaredActionBtnText.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: Colors.transparent),
        ),
      );

  /// Preset TextStyle
  TextStyle get defaultText => TextStyle();

  TextStyle get detailText => defaultText.copyWith(
        fontSize: fontSizeSmall,
        color: grey,
      );

  TextStyle get normalText => defaultText.copyWith(fontSize: fontSizeNormal);

  TextStyle get largeText => defaultText.copyWith(fontSize: fontSizeLarge);

  TextStyle get largeXLText => defaultText.copyWith(fontSize: fontSizeXL);

  TextStyle get largeXXLText => defaultText.copyWith(fontSize: fontSizeXXL);

  FontWeight get bold => FontWeight.bold;

  FontWeight get semiBold => FontWeight.w600;

  TextStyle get roundedActionBtnText => defaultText.copyWith(
        color: colorButtonText,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: 1.5,
      );

  TextStyle get squaredActionBtnText => defaultText.copyWith(
        color: colorButtonText,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      );
}
