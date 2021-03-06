import 'dart:io';
import 'dart:ui';

class KLocale {
  final String language;
  final String country;

  const KLocale({required this.language, required this.country});

  Locale toSystemLocale() => Locale(language, country);

  @override
  String toString() => "$language-$country";
}

abstract class KLocaleHelper {
  static const String TTS_LANGUAGE_EN = "en-US";
  static const String TTS_LANGUAGE_VI = "vi-VN";

  static const String LANGUAGE_EN = "en";
  static const String LANGUAGE_VI = "vi";

  static const String COUNTRY_US = "us";
  static const String COUNTRY_VN = "vn";

  static KLocale get defaultLocale => KLocale(
        language: LANGUAGE_EN,
        country: COUNTRY_US,
      );

  static String get localeName => Platform.localeName;

  static KLocale get currentLocale => _getLocale();

  static bool get isUSA => currentLocale.country == KLocaleHelper.COUNTRY_US;

  static bool get isVietnam =>
      currentLocale.country == KLocaleHelper.COUNTRY_VN;

  static KLocale _getLocale() {
    String lang = LANGUAGE_EN;
    String ctry = COUNTRY_US;

    KLocale locale = defaultLocale;
    try {
      List<String> zz =
          Platform.localeName.split('_').map((e) => e.toLowerCase()).toList();

      if (zz.length == 1)
        lang = zz[0];
      else if (zz.length >= 2) {
        lang = zz[0];
        ctry = zz[1];
      }

      locale =
          KLocale(language: lang.toLowerCase(), country: ctry.toLowerCase());
    } catch (e) {
      print(e.toString());
      locale = defaultLocale;
    }

    return locale;
  }
}
