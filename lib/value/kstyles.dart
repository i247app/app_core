import 'package:app_core/helper/service/ktheme_service.dart';
import 'package:app_core/style/kpalette.dart';
import 'package:app_core/style/kpalette_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  static Color get colorBGYes => Colors.green;

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
  static final String fontApercu = "Apercu";
  static final String fontUberMove = "UberMove";

  // static final String fontComfortaa = "Comfortaa";
  // static final String fontQuicksand = "Quicksand";

  static InputDecoration get roundedInputStyle => InputDecoration(
        fillColor: KThemeService.isDarkMode() ? Colors.white30 : Colors.black12,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
      );

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
  static ButtonStyle roundedButton(Color primary,
          {Color? textColor, double radius = 60}) =>
      ElevatedButton.styleFrom(
        foregroundColor: textColor ?? roundedActionBtnText.color,
        backgroundColor: primary,
        padding: EdgeInsets.symmetric(vertical: 12),
        textStyle: roundedActionBtnText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: Colors.transparent),
        ),
      );

  static ButtonStyle squaredButton(Color primary, {Color? textColor}) =>
      ElevatedButton.styleFrom(
        foregroundColor: textColor ?? squaredActionBtnText.color,
        backgroundColor: primary,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        textStyle: squaredActionBtnText,
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

  static Brightness getCurrentBrightness(BuildContext context) {
    return Theme.of(context).brightness;
  }

  static ThemeData themeDataBuilder(
    KPaletteGroup paletteGroup,
    Brightness brightness,
  ) {
    final palette = paletteGroup.getPaletteByBrightness(brightness);
    final baseTextTheme =
        // GoogleFonts.cabin()
        TextStyle().copyWith(
      package: 'app_core',
      fontFamily: fontApercu, // fontFamily: fontUberMove,
      color: palette.primary,
      fontWeight: FontWeight.normal,
    );
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: palette.contrasting,
      primaryColor: palette.primary,
      primaryColorLight: palette.primaryLight,
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: palette.schemePrimary),
      iconTheme: IconThemeData(color: palette.primaryLight),
      primaryIconTheme: IconThemeData(color: palette.primaryLight),
      textTheme: TextTheme(
        displayLarge: baseTextTheme.copyWith(fontWeight: FontWeight.bold),
        displayMedium: baseTextTheme.copyWith(),
        displaySmall: baseTextTheme.copyWith(),
        headlineLarge: baseTextTheme.copyWith(fontWeight: FontWeight.bold),
        headlineMedium: baseTextTheme.copyWith(),
        headlineSmall: baseTextTheme.copyWith(),
        titleLarge: baseTextTheme.copyWith(fontWeight: FontWeight.bold),
        titleMedium: baseTextTheme.copyWith(),
        titleSmall: baseTextTheme.copyWith(),
        bodyLarge: baseTextTheme.copyWith(fontWeight: FontWeight.bold),
        bodyMedium: baseTextTheme.copyWith(),
        bodySmall: baseTextTheme.copyWith(),
        labelLarge: baseTextTheme.copyWith(),
        labelSmall: baseTextTheme.copyWith(
          fontWeight: FontWeight.w400,
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.schemePrimary,
        foregroundColor: palette.contrasting,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.active,
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: palette.schemePrimary,
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
        fillColor: palette.primary,
        hintStyle: TextStyle(color: palette.primaryFaded),
        labelStyle: TextStyle(
          color: palette.primaryLight,
          fontSize: 16,
          letterSpacing: 0.15,
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: palette.primaryLight)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: palette.schemePrimary)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        counterStyle: TextStyle(color: palette.primary),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: palette.primaryLight,
        // indent: 16,
      ),
      cardTheme: CardTheme(
        color: palette.contrasting,
        shadowColor: palette.primaryLight,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return palette.active;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return palette.active;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return palette.active;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return palette.active;
          }
          return null;
        }),
      ),
      colorScheme: brightness == Brightness.dark
          ? ColorScheme.dark(
              primary: palette.schemePrimary,
              secondary: palette.schemeSecondary,
            )
          : ColorScheme.light(
              primary: palette.schemePrimary,
              secondary: palette.schemeSecondary,
            )
              .copyWith(error: palette.error)
              .copyWith(background: palette.contrasting),
    );
  }
}
