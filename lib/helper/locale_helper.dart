import 'dart:io';

class KLocale {
  final String language;
  final String country;

  const KLocale({required this.language, required this.country});
}

abstract class KLocaleHelper {
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

      locale = KLocale(language: lang, country: ctry);
    } catch (e) {
      print(e.toString());
      locale = defaultLocale;
    }

    return locale;
  }
}
