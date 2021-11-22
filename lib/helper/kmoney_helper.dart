import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kmath_helper.dart';
import 'package:intl/intl.dart';

class KMoney {
  static const String USD = "USD";
  static const String VND = "VND";
  static const String CHAO = "CHAO";

  final String amount;
  final int decimals; // TODO how many decimal places are available
  final String currency;

  const KMoney({
    required this.amount,
    required this.decimals,
    required this.currency,
  });

  KMoney operator +(KMoney m) => KMoney(
        amount: KMathHelper.add(amount, m.amount),
        decimals: decimals,
        currency: currency,
      );

  @override
  String toString() => KMoneyHelper.prettyMoney(
        amount: amount,
        currency: currency,
      );
}

abstract class KMoneyHelper {
  /// Nicely format money
  static String prettyMoney({
    required String amount,
    required String currency,
    bool showSymbol = true,
  }) {
    // Sanitize the locale for NumberFormat
    KLocale locale = KLocaleHelper.currentLocale;
    if (!NumberFormat.localeExists(locale.toString()))
      locale = KLocaleHelper.defaultLocale;

    final format = NumberFormat.decimalPattern(locale.toString());
    final formatAmt = formatByCurrency(
      amt: format.format(KMathHelper.smartParse(amount)),
      currency: currency,
    );

    if (showSymbol) {
      final isSymbolAsPrefix = currencySymbol(currency) != currency;
      return isSymbolAsPrefix
          ? "${currencySymbol(currency)} $formatAmt"
          : "$formatAmt ${currencySymbol(currency)}";
    } else {
      return formatAmt;
    }
  }

  /// Currency code to true currency symbol
  static String currencySymbol(String currency) {
    final symbol;
    switch (currency) {
      case KMoney.VND:
        symbol = "₫";
        break;
      case KMoney.USD:
        symbol = "\$";
        break;
      default:
        symbol = currency;
        break;
    }
    return symbol;
  }

  /// Modify string to follow currency's locale formatting
  static String formatByCurrency({
    required String amt,
    required String currency,
  }) {
    final formatAmt;
    switch (currency) {
      case KMoney.VND:
        formatAmt = amt.replaceAll(",", ".");
        break;
      case KMoney.USD:
      default:
        formatAmt = amt;
        break;
    }
    return formatAmt;
  }
}
