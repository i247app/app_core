import 'dart:ui';

import 'package:app_core/style/kpalette.dart';
import 'package:app_core/helper/krebuild_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// set _brightness to set default dark/light
// _brightness > brightnessTheme > themeColor > palette
@deprecated
abstract class KStyles {
  static const double leftPanelWidth = 270;
  static const double smallestSize = 600;
  static const double maxWidth = 390;
  static const Brightness DEFAULT_BRIGHTNESS = Brightness.light;

  /// Theme Brightness
  static Brightness _brightness = DEFAULT_BRIGHTNESS;

  static Brightness get brightnessTheme => _brightness;

  static void setBrightnessTheme(Brightness brightness) {
    _brightness = brightness;
    KRebuildHelper.forceRebuild();
  }

  static void toggleBrightnessTheme() => setBrightnessTheme(
      brightnessTheme == Brightness.dark ? Brightness.light : Brightness.dark);

  /* Base Colors */
  static final Color white = Colors.white; //Color(0xfffafafa);
  static final Color black = Color(0xff111111);
  static final Color green = Colors.green; //Color(0xfffafafa);
  static final Color extraExtraLightGrey = Color(0xffefefef);
  static final Color extraLightGrey = Color(0xffdedede);
  static final Color chatGrey = Color(0xff8b8b8b);
  static final Color lightGrey = Color(0xffbbbbbb);
  static final Color superLightGrey = Color(0xffdddddd);
  static final Color grey = Color(0xff888888);
  static final Color darkGrey = Color(0xff666666);
  static final Color extraDarkGrey = Color(0xff333333);
  static final Color blueFaded = Color(0xffcce5ff);
  static final Color blue = Colors.blue;

  /// Colors - perhaps better named as paletteColor
  static KPalette paletteLight = KPalette(
    palettePrimary: Color(0xff0088DD),
    paletteSecondary: Color(0xff0099EE),
    paletteSupport: Color(0xff0099EE),
    paletteButtonText: white,
    palette4: Color(0xff0099EE),
    palette5: Color(0xff0099EE),
    yes: Color(0xff79AF2C),
    no: Colors.red,
  );

  static KPalette paletteDark = paletteLight;

  /* Theme Colors */
  static KPalette get themeColors =>
      _brightness == Brightness.dark ? paletteDark : paletteLight;

  static Color get colorButton => themeColors.palettePrimary;

  static Color get colorButtonText => themeColors.paletteButtonText;

  static Color get colorIcon => themeColors.palettePrimary;

  static Color get colorBGYes => themeColors.palettePrimary;

  static Color get colorBGNo => Colors.red;

  static Color get colorSuccess => Colors.green;

  static Color get colorWarning => Colors.orange;

  static Color get colorError => Colors.red;

  static Color get colorRequiredField => Colors.red;

  static Color get colorPrimary => themeColors.palettePrimary;

  static Color get colorSecondary => themeColors.paletteSecondary;

  static Color get colorFormBorder => Color(0xffdddddd);

  static Color get colorDivider => extraLightGrey;

  /// Dimensions
  static final double fontSizeSmall = 14;
  static final double fontSizeNormal = 16;
  static final double fontSizeLarge = 18;
  static final double fontSizeXL = 24;
  static final double fontSizeXXL = 28;

  static final double headerFontSize = fontSizeLarge;

  /// Fonts
  static final String fontComfortaa = "Comfortaa";
  static final String fontQuicksand = "Quicksand";

  /// SystemUiOverlayStyle
  static SystemUiOverlayStyle get systemStyle =>
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      );

  /// Preset InputDecoration
  static InputDecoration get inputDecoration => InputDecoration(
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(60)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );

  /// Preset ButtonStyle
  static ButtonStyle roundedButton(Color primary, {Color? textColor}) =>
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

  static ButtonStyle squaredButton(Color primary, {Color? textColor}) =>
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
  static TextStyle get defaultText => TextStyle();

  static TextStyle get detailText => defaultText.copyWith(
        fontSize: fontSizeSmall,
        color: KStyles.brightnessTheme == Brightness.light
            ? grey
            : extraExtraLightGrey,
      );

  static TextStyle get normalText =>
      defaultText.copyWith(fontSize: fontSizeNormal);

  static TextStyle get largeText =>
      defaultText.copyWith(fontSize: fontSizeLarge);

  static TextStyle get largeXLText =>
      defaultText.copyWith(fontSize: fontSizeXL);

  static TextStyle get largeXXLText =>
      defaultText.copyWith(fontSize: fontSizeXXL);

  static FontWeight get bold => FontWeight.bold;

  static FontWeight get semiBold => FontWeight.w600;

  static TextStyle get roundedActionBtnText => defaultText.copyWith(
        color: colorButtonText,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: 1.5,
      );

  static TextStyle get squaredActionBtnText => defaultText.copyWith(
        color: colorButtonText,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      );

  // TODO - delete
  static const double SPACING_SMALL = 4;
  static const double SPACING_NORMAL = 8;
  static const double SPACING_LARGE = 12;
}
