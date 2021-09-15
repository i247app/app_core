import 'package:app_core/app_core.dart';
import 'package:app_core/style/kbase_theme.dart';
import 'package:app_core/style/kpalette.dart';
import 'package:app_core/style/kpalette_group.dart';
import 'package:app_core/style/ksmart_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class KTheme extends KBaseTheme {
  ///
  /// InheritedWidget stuff
  ///
  KTheme({
    required Widget child,
    required KPaletteGroup paletteGroup,
  }) : super(child: child, paletteGroup: paletteGroup);

  static KTheme of(BuildContext context) {
    final KTheme? result = context.dependOnInheritedWidgetOfExactType<KTheme>();
    assert(result != null, 'No KTheme found in context');
    return result!;
  }

  ///
  /// Styles stuff
  ///
  KSmartThemeData get smartThemeData => KSmartThemeData(
        paletteGroup: this.paletteGroup,
        brightness: this.systemBrightness,
      );

  final double leftPanelWidth = 270;
  final double smallestSize = 600;
  final double maxWidth = 390;

  /* Base Colors */
  final Color white = Colors.white; //Color(0xfffafafa);
  final Color black = Color(0xff111111);
  final Color green = Colors.green; //Color(0xfffafafa);
  final Color extraExtraLightGrey = Color(0xffefefef);
  final Color extraLightGrey = Color(0xffdedede);
  final Color chatGrey = Color(0xff8b8b8b);
  final Color lightGrey = Color(0xffbbbbbb);
  final Color superLightGrey = Color(0xffdddddd);
  final Color grey = Color(0xff888888);
  final Color darkGrey = Color(0xff666666);
  final Color extraDarkGrey = Color(0xff333333);
  final Color blueFaded = Color(0xffcce5ff);
  final Color blue = Colors.blue;

  /// Colors - perhaps better named as paletteColor
  //  KPalette paletteLight = KPalette(
  //   palettePrimary: Color(0xff0088DD),
  //   paletteSecondary: Color(0xff0099EE),
  //   paletteSupport: Color(0xff0099EE),
  //   paletteButtonText: white,
  //   palette4: Color(0xff0099EE),
  //   palette5: Color(0xff0099EE),
  //   yes: Color(0xff79AF2C),
  //   no: Colors.red,
  //   systemTheme: ThemeData(
  //     primarySwatch: Colors.blue, // TODO make this a custom color
  //     primaryColor: KStyles.white,
  //     backgroundColor: KStyles.white,
  //     brightness: Brightness.light,
  //   ),
  // );
  //
  //  KPalette paletteDark = paletteLight;

  /* Theme Colors */
  Color get colorButton => this.activePalette.palettePrimary;

  Color get colorButtonText => this.activePalette.paletteButtonText;

  Color get colorIcon => this.activePalette.palettePrimary;

  Color get colorBGYes => this.activePalette.palettePrimary;

  Color get colorBGNo => Colors.red;

  Color get colorSuccess => Colors.green;

  Color get colorWarning => Colors.orange;

  Color get colorError => Colors.red;

  Color get colorRequiredField => Colors.red;

  Color get colorPrimary => this.activePalette.palettePrimary;

  Color get colorSecondary => this.activePalette.paletteSecondary;

  Color get colorFormBorder => Color(0xffdddddd);

  Color get colorDivider => extraLightGrey;

  /// Dimensions
  final double fontSizeSmall = 14;
  final double fontSizeNormal = 16;
  final double fontSizeLarge = 18;
  final double fontSizeXL = 24;
  final double fontSizeXXL = 28;

  /// Fonts
  final String fontComfortaa = "Comfortaa";
  final String fontQuicksand = "Quicksand";

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
        padding: EdgeInsets.symmetric(vertical: 12),
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
        color: this.systemBrightness == Brightness.light
            ? grey
            : extraExtraLightGrey,
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

  // TODO - delete
  static const double SPACING_SMALL = 4;
  static const double SPACING_NORMAL = 8;
  static const double SPACING_LARGE = 12;
}
