import 'package:app_core/style/kbase_theme.dart';
import 'package:app_core/style/kpalette_group.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';
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

  ThemeData get themeData => KStyles.themeDataBuilder(activePalette);

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

  /* Theme Colors */
  Color get colorButton => activePalette.primary;

  Color get colorButtonText => white;

  Color get colorIcon => activePalette.primary;

  Color get colorBGYes => activePalette.primary;

  Color get colorBGNo => Colors.red;

  Color get colorSuccess => Colors.green;

  Color get colorWarning => Colors.orange;

  Color get colorError => Colors.red;

  Color get colorRequiredField => Colors.red;

  Color get colorPrimary => activePalette.primary;

  Color get colorSecondary => activePalette.contrasting;

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
        color: isLightMode ? grey : extraExtraLightGrey,
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
