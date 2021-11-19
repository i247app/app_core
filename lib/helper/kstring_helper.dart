import 'package:tiengviet/tiengviet.dart';

abstract class KStringHelper {
  static const String TRUE = "T";
  static const String FALSE = "F";

  static const String USERNAME_VALIDATION_PATTERN = "a-zA-Z0-9.@-_";
  static const String PASSWORD_VALIDATION_PATTERN = "a-zA-Z0-9.@-_";

  static bool isEmpty(final String? z) => z == null || z.isEmpty;

  static bool isExist(final String? z) => !isEmpty(z);

  static String nvlSingle(String? z) => z ?? "";

  static String nvlMany(List<String?> many) {
    String? result;
    for (String? z in many) {
      result = z;
      if (isExist(result)) break;
    }
    return nvlSingle(result);
  }

  static String nvl(var arg) {
    String? result;
    try {
      switch (arg.runtimeType) {
        case List:
          result = nvlMany(arg);
          break;
        case String:
          result = nvlSingle(arg);
          break;
      }
    } catch (e) {}
    return nvlSingle(result);
  }

  static bool isEmail(final String z) {
    const String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return RegExp(emailPattern).hasMatch(z);
  }

  static bool isPhone(final String z) => isExist(z); // TODO

  static int atoi(String z) => int.parse(z);

  static String itoa(int num) => num.toString();

  static String dtoa(double? num) => num != null ? num.toString() : "";

  static bool parseBoolean(String z) {
    bool b = false;
    switch (z.toUpperCase()) {
      case TRUE:
      case "TRUE":
      case "ON":
      case "YES":
        b = true;
        break;
      case FALSE:
      case "FALSE":
      case "OFF":
      case "NO":
      default:
        b = false;
        break;
    }
    return b;
  }

  static String toBooleanCode(bool b) => b ? TRUE : FALSE;

  static String removeWhiteSpace(String z) {
    try {
      z = z.replaceAll(' ', '');
    } catch (e) {
      z = "";
    }
    return z;
  }

  static String normalizeForSearch(String z) =>
      KStringHelper.stripVietnameseAccents(z).toLowerCase();

  static String removePattern(String z, String pattern) =>
      z.replaceAll(RegExp("[^$pattern]"), "");

  static bool validate(String z, String pattern) =>
      z == removePattern(z, pattern);

  static String capitalize(String z) {
    String result = z;
    try {
      result =
          z.length > 1 ? z[0].toUpperCase() + z.substring(1) : z.toUpperCase();
    } catch (e) {}
    return result;
  }

  static String toInitials({String? name, bool isFirstOnly = false}) {
    if (isFirstOnly) {
      return KStringHelper.isEmpty(name ?? '')
          ? "?"
          : name!.substring(0, 1).toUpperCase();
    } else {
      return name != null && name.isNotEmpty
          ? name
              .trim()
              .split(' ')
              .map((l) => l[0])
              .take(name.trim().split(' ').length)
              .join()
          : '';
    }
  }

  static String substring(String z, int start, [int? end]) {
    String sub;
    try {
      sub = z.substring(start, end);
    } catch (e) {
      sub = z;
    }
    return sub;
  }

  static String stripHTML(String z) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return z.replaceAll(exp, '');
  }

  static String stripVietnameseAccents(String z) => TiengViet.parse(z);
}
