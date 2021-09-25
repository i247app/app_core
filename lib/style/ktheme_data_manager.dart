import 'package:app_core/app_core.dart';
import 'package:app_core/style/kpalette_group.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The Material Design typography scheme was significantly changed in the
/// current (2018) version of the specification
/// ([https://material.io/design/typography](https://material.io/design/typography)).
///
/// The 2018 spec has thirteen text styles:
/// ```
/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
/// ```
class KThemeDataManager {
  final KPaletteGroup paletteGroup;

  ThemeData get lightThemeData =>
      this.themeDataBuilder(this.paletteGroup.light);

  ThemeData get darkThemeData => this.themeDataBuilder(this.paletteGroup.dark);

  const KThemeDataManager(this.paletteGroup);

  ThemeData themeDataBuilder(KPalette palette) => ThemeData(
        primaryColor: palette.palettePrimary,
        errorColor: Colors.red,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        textTheme: GoogleFonts.openSansTextTheme(
          TextTheme(
            headline1: TextStyle(
              color: palette.palettePrimary,
              fontWeight: FontWeight.normal,
            ),
            headline2: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            headline4: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            headline5:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            headline6:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
            subtitle1:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
            subtitle2:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
            bodyText1:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
            bodyText2:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.normal),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          centerTitle: false,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: palette.palettePrimary,
          unselectedItemColor: Colors.black87,
          backgroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: palette.palettePrimary,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12),
            textStyle: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 1.5,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
              side: BorderSide(color: Colors.transparent),
            ),
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 1.5,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
          labelStyle: TextStyle(
              color: Colors.black87, fontSize: 16, letterSpacing: 0.15),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black12,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: palette.palettePrimary),
          ),
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          counterStyle: TextStyle(color: Colors.grey),
        ),
        dividerTheme: DividerThemeData(
          thickness: 1,
          color: Colors.grey.shade300,
          indent: 16,
        ),
        cardTheme: CardTheme(color: Colors.white, shadowColor: Colors.white70),
      );
}