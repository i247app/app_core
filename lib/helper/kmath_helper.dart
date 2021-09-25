abstract class KMathHelper {
  /// parse double
  static int parseInt(String? v, {int? radix}) {
    int i = 0;
    try {
      i = int.tryParse(v ?? "0", radix: radix) ?? 0;
    } catch (e) {
      i = 0;
    }
    return i;
  }

  /// parse double
  static double parseDouble(String? v) {
    double d = 0;
    try {
      d = double.tryParse(v ?? "0") ?? 0;
    } catch (e) {
      d = 0;
    }
    return d;
  }

  /// Negate
  static String negate(String z) {
    String result = z;
    try {
      if (result.startsWith("-"))
        result = result.substring(1);
      else
        result = "-" + result;
    } catch (e) {}
    return result;
  }

  /// Absolute value
  static String abs(String z) {
    String result = z;
    try {
      if (result.startsWith("-")) result = result.substring(1);
    } catch (e) {}
    return result;
  }

  /// Test for negative
  static bool gte(String a, String b) {
    bool z = false;
    try {
      z = double.parse(a) >= double.parse(b);
    } catch (e) {}
    return z;
  }

  static bool isDecimal(String? z) => (z ?? "").contains(".");

  static bool isInt(String? z) => !isDecimal(z);

  /// Test for negative
  static bool isNegative(String z) {
    bool b = false;
    try {
      b = double.parse(z).isNegative;
    } catch (e) {}
    return b;
  }

  /// Test for positive
  static bool isPositive(String z) => !isNegative(z);

  /// Add two values
  static String add(String? a, String? b) {
    final method = (isDecimal(a) || isDecimal(b)) ? parseDouble : parseInt;
    return ((method.call(a ?? "0")) + (method.call(b ?? "0"))).toString();
  }

  /// Subtract two values
  static String sub(String? a, String? b) =>
      ((double.tryParse(a ?? "0") ?? 0) - (double.tryParse(b ?? "0") ?? 0))
          .toString();

  /// Multiply two values
  static String mult(String? a, String? b) =>
      ((double.tryParse(a ?? "1") ?? 1) * (double.tryParse(b ?? "1") ?? 1))
          .toString();

  /// Divide two values
  static String div(String? a, String? b) =>
      (parseDouble(a ?? "1") / parseDouble(b ?? "1")).toString();
}
