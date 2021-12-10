import 'dart:ui';

import 'package:app_core/helper/service/ktheme_service.dart';
import 'package:app_core/style/kpalette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// set _brightness to set default dark/light
// _brightness > brightnessTheme > themeColor > palette
abstract class KStyles {
  static const double leftPanelWidth = 270;
  static const double smallestSize = 600;
  static const double maxWidth = 390;

  /// Theme Brightness

  static Brightness get brightnessTheme =>
      KThemeService.getThemeMode() == ThemeMode.system
          ? (KThemeService.isDarkMode() ? Brightness.dark : Brightness.light)
          : KThemeService.getThemeMode() == ThemeMode.dark
              ? Brightness.dark
              : Brightness.light;

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
    primary: Color(0xff0088DD),
    primaryLight: Color(0xff0088DD),
    contrasting: Color(0xff0099EE),
    primaryFaded: Color(0xff0099EE),
    active: Color(0xff0099EE),
    error: Colors.red,
    schemePrimary: Colors.blue,
    schemeSecondary: Color(0xff0099EE),
  );

  static KPalette paletteDark = paletteLight;

  /* Theme Colors */
  static KPalette get themeColors =>
      brightnessTheme == Brightness.dark ? paletteDark : paletteLight;

  static Color get colorButton => themeColors.primary;

  static Color get colorButtonText => Colors.white;

  static Color get colorIcon => themeColors.primary;

  static Color get colorBGYes => themeColors.primary;

  static Color get colorBGNo => Colors.red;

  static Color get colorSuccess => Colors.green;

  static Color get colorWarning => Colors.orange;

  static Color get colorError => Colors.red;

  static Color get colorRequiredField => Colors.red;

  static Color get colorPrimary => Colors.blue; // themeColors.primary;

  static Color get colorSecondary => themeColors.contrasting;

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

  static ThemeData themeDataBuilder(KPalette palette) =>
      ThemeData(brightness: brightnessTheme).copyWith(
        colorScheme: brightnessTheme == Brightness.dark
            ? ColorScheme.dark(
                primary: palette.schemePrimary,
                secondary: palette.schemeSecondary,
              )
            : ColorScheme.light(
                primary: palette.schemePrimary,
                secondary: palette.schemeSecondary,
              ),
        backgroundColor: palette.contrasting,
        scaffoldBackgroundColor: palette.contrasting,
        primaryColor: palette.primary,
        primaryColorLight: palette.primaryLight,
        errorColor: palette.error,
        toggleableActiveColor: palette.active,
        textSelectionTheme: TextSelectionThemeData(cursorColor: colorPrimary),
        iconTheme: IconThemeData(color: palette.primaryLight),
        primaryIconTheme: IconThemeData(color: palette.primaryLight),
        textTheme: GoogleFonts.openSansTextTheme(
          TextTheme(
            headline1: TextStyle(
                color: palette.primary, fontWeight: FontWeight.normal),
            headline2: TextStyle(
                color: palette.primary, fontWeight: FontWeight.normal),
            headline4: TextStyle(
                color: palette.primary, fontWeight: FontWeight.normal),
            headline5: TextStyle(
                color: palette.primary, fontWeight: FontWeight.normal),
            headline6: TextStyle(
                color: palette.primary, fontWeight: FontWeight.normal),
            subtitle1: TextStyle(
                color: palette.primary, fontWeight: FontWeight.normal),
            subtitle2: TextStyle(
                color: palette.primary, fontWeight: FontWeight.normal),
            bodyText1: TextStyle(
                color: palette.primary, fontWeight: FontWeight.normal),
            bodyText2: TextStyle(
                color: palette.primary, fontWeight: FontWeight.normal),
            caption: TextStyle(
                color: palette.primary, fontWeight: FontWeight.normal),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: palette.contrasting,
          elevation: 0,
          iconTheme: IconThemeData(color: palette.primary),
          titleTextStyle: TextStyle(color: palette.primary, fontSize: 20),
          centerTitle: false,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: palette.primary,
          unselectedItemColor: palette.primaryLight,
          elevation: 1,
          backgroundColor: palette.contrasting,
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: palette.primary),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: palette.active,
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 1.5,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: palette.schemePrimary,
            onPrimary: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
              side: BorderSide(color: Colors.transparent),
            ),
            textStyle: TextStyle(
              color: palette.primary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 1.5,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: palette.primary),
          labelStyle: TextStyle(
            color: palette.primaryLight,
            fontSize: 16,
            letterSpacing: 0.15,
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: palette.primaryLight)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: palette.primary)),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          counterStyle: TextStyle(color: palette.primary),
        ),
        dividerTheme: DividerThemeData(
          thickness: 1,
          color: palette.primary,
          // indent: 16,
        ),
        cardTheme: CardTheme(
          color: palette.contrasting,
          shadowColor: palette.primaryLight,
        ),
      );
}
