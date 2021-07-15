import 'dart:io';

class AppCoreKLocale {
  final String language;
  final String country;

  const AppCoreKLocale({required this.language, required this.country});
}

abstract class AppCoreLocaleHelper {
  static const String LANGUAGE_EN = "en";
  static const String LANGUAGE_VI = "vi";

  static const String COUNTRY_US = "us";
  static const String COUNTRY_VN = "vn";

  static AppCoreKLocale get defaultLocale => AppCoreKLocale(
    language: LANGUAGE_EN,
    country: COUNTRY_US,
  );

  static String get localeName => Platform.localeName;

  static AppCoreKLocale get currentLocale => _getLocale();

  static AppCoreKLocale _getLocale() {
    String lang = LANGUAGE_EN;
    String ctry = COUNTRY_US;

    AppCoreKLocale locale = defaultLocale;
    try {
      List<String> zz =
      Platform.localeName.split('_').map((e) => e.toLowerCase()).toList();

      if (zz.length == 1)
        lang = zz[0];
      else if (zz.length >= 2) {
        lang = zz[0];
        ctry = zz[1];
      }

      locale = AppCoreKLocale(language: lang, country: ctry);
    } catch (e) {
      print(e.toString());
      locale = defaultLocale;
    }

    return locale;
  }
}
