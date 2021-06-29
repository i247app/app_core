import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:app_core/helper/date_helper.dart';
import 'package:app_core/helper/device_id_helper.dart';
import 'package:app_core/helper/locale_helper.dart';
import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/helper/tablet_detector.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:timeago/timeago.dart' as timeago;

abstract class Util {
  static Random _random = Random();
  static String? _buildVersion;
  static String? _buildNumber;

  static String get buildVersion => Util._buildVersion ?? "";

  static String get buildNumber => Util._buildNumber ?? "";

  static Future<String> getDeviceID() async => DeviceIDHelper.deviceID;

  static Future<String> getDeviceBrand() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return Platform.isAndroid ? (await deviceInfo.androidInfo).brand : 'Apple';
  }

  static Future<String> getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return Platform.isAndroid
        ? (await deviceInfo.androidInfo).model
        : (await deviceInfo.iosInfo).name;
  }

  static Future<String> getDeviceVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return Platform.isAndroid
        ? (await deviceInfo.androidInfo).version.release
        : (await deviceInfo.iosInfo).systemVersion;
  }

  static Future<String> getDeviceName() async {
    String brand = await getDeviceBrand();
    String model = await getDeviceModel();
    String version = await getDeviceVersion();
    return "$brand-$model $version";
  }

  static Future<bool> isPhysicalDevice() async =>
      (await DeviceInfoPlugin().androidInfo).isPhysicalDevice;

  static Future<bool> isEmulator() async => isPhysicalDevice().then((b) => !b);

  static String localeName() => LocaleHelper.localeName;

  static String getPlatformCode() => Platform.operatingSystem;

  static Random getRandom() => _random;

  static Color getRandomColor() => Color.fromRGBO(getRandom().nextInt(0xFF),
      getRandom().nextInt(0xFF), getRandom().nextInt(0xFF), 0x01);

  static Color colorFromString(String z) {
    int num = 0;
    for (int i = 0; i < z.length; i++) num += z.codeUnitAt(i);
    return Colors.primaries[num % Colors.primaries.length];
  }

  static String prettyJSON(final data) {
    final encoder = JsonEncoder.withIndent("     ");
    return encoder.convert(data is String ? jsonDecode(data) : data);
  }

  static Future<bool> isTabletDevice(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return TabletDetector.isTablet(MediaQuery.of(context)) ||
        (Platform.isIOS &&
            (await deviceInfo.iosInfo).name.toLowerCase().contains("ipad"));
  }

  static String prettyXFRDescription({String? lineType, String? xfrType}) {
    String z = "";

    switch (xfrType) {
      case "DXFR":
        z = "Direct Transfer";
        break;
      case "EXFR":
        z = "Escrow Transfer";
        break;
      case "DEP":
        z = "Deposit";
        break;
      case "WDL":
        z = "Withdrawal";
        break;
      case "FEE":
        z = "Transaction Fee";
        break;
      case "MINT":
        z = "Mint";
        break;
      case "GENI":
        z = "Genesis";
        break;
      default:
        break;
    }

    return z;
  }

  static String maskedFone(String fone) {
    if (fone.length <= 4) {
      return fone.replaceAll(RegExp(r'.'), 'x');
    }
    return fone.replaceAll(RegExp(r'.'), 'x').substring(0, fone.length - 4)+fone.substring(fone.length - 4);
  }

  static String prettyFone({String foneCode = "", String number = ""}) {
    foneCode = foneCode.replaceAll("+", "");
    String prefix = StringHelper.isExist(foneCode) ? "+" + foneCode + " " : "";
    return prefix + (number != null ? number : "");
  }

  // TODO VN - last, middle first else first middle last
  static String? prettyName(
      {String fnm = "", String mnm = "", String lnm = ""}) {
    String? title;

    try {
      title = StringHelper.capitalize(fnm);

      if (!StringHelper.isEmpty(mnm))
        title += " " + StringHelper.capitalize(mnm);
      if (!StringHelper.isEmpty(lnm))
        title += " " + StringHelper.capitalize(lnm);
    } catch (e) {
      title = null;
    }
    if (title == "") {
      return null;
    }
    return title;
  }

  static String? chatDisplayName(
      {String? kunm = "",
      String? fnm = "",
      String? mnm = "",
      String? lnm = ""}) {
    String? title;

    try {
      title = "";

      if (!StringHelper.isEmpty(kunm)) title += "@${kunm}";
      if (!StringHelper.isEmpty(fnm))
        title += " " + StringHelper.capitalize(fnm ?? "");
      if (!StringHelper.isEmpty(mnm))
        title += " " + StringHelper.capitalize(mnm ?? "");
      if (!StringHelper.isEmpty(lnm))
        title += " " + StringHelper.capitalize(lnm ?? "");
    } catch (e) {
      title = null;
    }

    return title;
  }

  // Anna L H. - name with last initial
  static String privacyName(
      {String fnm = "", String mnm = "", String lnm = ""}) {
    String title = "";

    try {
      title = fnm != null ? fnm : "";

      if (!StringHelper.isEmpty(mnm))
        title += " " + StringHelper.toInitials(name: mnm);

      if (!StringHelper.isEmpty(lnm))
        title += " " + StringHelper.toInitials(name: lnm);
    } catch (e) {
      title = "";
      print(e);
    }

    return title;
  }

  static String ampDisplayName(
      {String? bnm = "",
      String fnm = "",
      String mnm = "",
      String lnm = "",
      String? fone = ""}) {
    return bnm ??
        (Util.privacyName(fnm: fnm, mnm: mnm, lnm: lnm) != null
            ? Util.privacyName(fnm: fnm, mnm: mnm, lnm: lnm)
            : (fone ?? ""));
  }

  static String absNumber(String v) {
    String z = "0";
    try {
      z = (double.tryParse(v) ?? 0).abs().toString();
    } catch (e) {
      z = "0";
    }
    return z;
  }

  // TODO - currency Name override symbol. perhaps use int instead???
  // no exception thrown
  // return "0" on amount on any errors
  // currencyName true
  //  - VND - comma separator - 24.500 VND or 24.500,55 VND
  //  - USD - dot separator   - 24,500 USD or 24,500.55 USD
  // currencySymbol true
  //  - VND - comma separator - 24.500 d or 24.500,55 d
  //  - USD - dot separator   - $24,500 or $24,500.55
  // currencyName/currencySymbol false
  //  - VND - comma separator - 24.500 or 24.500,55
  //  - USD - dot separator   - 24,500 or 24,500.55
  static String prettyMoney({
    String? amount,
    String? tokenName,
    bool useCurrencySymbol = true,
    bool useCurrencyName = false,
  }) {
    double dAmount = double.tryParse(amount ?? "0") ?? 0;

    String pretty = "0";
    try {
      switch (tokenName ?? "") {
        case "USD":
          if (useCurrencyName) // USD1,234.56 or USD1,234.00
            pretty = NumberFormat.currency(locale: "en").format(dAmount);
          else if (useCurrencySymbol) // $1,234.56 or $1,234.00
            pretty = NumberFormat.simpleCurrency(locale: "en").format(dAmount);
          else // 1,234.56 or 1,234.00
            pretty = NumberFormat("#,##0.00", "en_US").format(dAmount);
          break;
        case "VND": // for vnd and eur
          if (useCurrencyName) // 1.234,56 VND or 1.234 VND
            pretty = NumberFormat.currency(locale: "vi").format(dAmount);
          else if (useCurrencySymbol) // 1.234,56 d or 1.234 d
            pretty = NumberFormat.simpleCurrency(locale: "vi").format(dAmount);
          else // 1.234,56 or 1.234
            pretty = NumberFormat("#,###.##", "vi_VN").format(dAmount);
          break;
        case "CHAO": // for vnd and eur
          if (useCurrencyName) // 1.234,56 VND or 1.234 VND
            pretty = NumberFormat.currency(locale: "vi").format(dAmount);
          else if (useCurrencySymbol) // 1.234,56 d or 1.234 d
            pretty = NumberFormat.simpleCurrency(locale: "vi").format(dAmount);
          else // 1.234,56 or 1.234
            pretty = NumberFormat("#,###.##", "vi_VN").format(dAmount);
          break;
        default: // default locale most likely en or vi
          if (useCurrencyName) // 1.234,56 VND or 1.234 VND
            pretty = NumberFormat.currency().format(dAmount);
          if (useCurrencySymbol) // 1.234,56 d or 1.234 d
            pretty = NumberFormat.simpleCurrency().format(dAmount);
          else // 1.234,56 or 1.234
            pretty = NumberFormat("#,###.##").format(dAmount);
          break;
      }
    } catch (e) {
      pretty = "0";
    }

    return pretty;
  }

  // VND - comma separator - 24.500 or 24.500,55
  // USD - dot separator   - 24,500 or 24,500.55
  // null tokenName, default dot separator format
  static String? prettyNumber({String? number, String? tokenName}) {
    String pretty;

    if (number == "" || number == null) {
      return null;
    }

    try {
      switch (tokenName) {
        case "VND":
          pretty =
              NumberFormat("###.##", "vi_VN").format(double.tryParse(number));
          break;
        case "USD":
          pretty =
              NumberFormat("##0.00", "en_US").format(double.tryParse(number));
          break;
        default:
          pretty = NumberFormat("###.##").format(double.tryParse(number));
          break;
      }
    } catch (e) {
      return null;
    }

    return pretty;
  }

  static String dotSeparatorNumbers({String? amount = ""}) {
    String z = "";

    try {
      // Normalize input
      amount = double.parse(amount ?? "").toString();
      if (amount.endsWith(".0"))
        amount = amount.substring(0, amount.length - 2);

      // Check for negative value
      bool isNegative = false;
      if (amount[0] == "-") {
        isNegative = true;
        amount = amount.substring(1);
      }

      // Split at decimal
      String integerPart = "";
      String fractionalPart = "";
      try {
        integerPart = amount.split('.')[0];
        fractionalPart = amount.split('.')[1];
      } catch (e) {}

      // Build balance in reverse
      for (int i = integerPart.length - 1; i >= 0; i--) {
        int indexFromRight = integerPart.length - 1 - i;
        if (indexFromRight != 0 && indexFromRight % 3 == 0) z += ".";
        z += integerPart[i];
      }

      // Reverse string to right direction
      z = z.split('').reversed.join('');

      // Add minus sign if negative value
      if (isNegative) z = "-" + z;

      // Append fractional part if exists
      if (fractionalPart != null) z = z + "." + fractionalPart;
    } catch (e) {
      z = amount ?? "";
    }
    return z;
  }

  static Future<String> getPackageName() =>
      PackageInfo.fromPlatform().then((p) => p.packageName);

  // WARNING - isUTC or not
  static String timeAgo(dynamic rawDate) {
    String pretty = "";
    try {
      // Convert input to DateTime object
      DateTime? date;
      switch (rawDate.runtimeType) {
        case DateTime:
          date = DateHelper.copy(rawDate);
          break;
        case String:
        default:
          date = DateHelper.from20FSP(rawDate.toString());
          break;
      }

      if (date != null) {
        if (date.isUtc) print("Util.timeAgo date is utc");
        // date = date.toLocal(); // localized for display only

        date = date.toLocal();

        pretty = timeago.format(date);
      }
    } catch (e) {
      pretty = "";
    }

    return pretty;
  }

  // WARNING - isUTC or not
  static String prettyDate(
    dynamic rawDate, {
    bool showTime = false,
    bool abbreviate = false,
    bool is24H = true,
  }) {
    String pretty = "";

    try {
      // Convert input to DateTime object
      DateTime? date;
      switch (rawDate.runtimeType) {
        case DateTime:
          date = DateHelper.copy(rawDate);
          break;
        case String:
        default:
          date = DateHelper.from20FSP(rawDate.toString(), isUTC: false);
          break;
      }

      if (date != null && date.isUtc) {
        print("a date is utc");
        date = date.toLocal(); // localized for display only
      }

      // Build pretty string
      try {
        String format = "";

        if (abbreviate) {
          format = "E, MMM dd";
        } else {
          format = "yyyy-MM-dd";
          if (showTime) {
            if (is24H)
              format = format + " HH:mm:ss";
            else
              format = format + " hh:mm:ss aaa";
          }
        }

        if (date != null) {
          pretty = DateFormat(format).format(date);
        }
      } catch (e) {
        print(e.toString());
        // pretty = date.toIso8601String();
        pretty = 'hellobye';
      }
    } catch (e) {
      pretty = "";
    }

    return pretty;
  }

  // WARNING - isUTC or not
  static String prettyTime(
    dynamic rawDate, {
    bool showSeconds = false,
    bool showMeridiem = false,
    bool is24H = true,
  }) {
    String pretty = "";
    try {
      // Convert input to DateTime object
      DateTime? date;
      switch (rawDate.runtimeType) {
        case DateTime:
          date = DateHelper.copy(rawDate);
          break;
        case String:
        default:
          date = DateHelper.from20FSP(rawDate.toString());
          break;
      }

      if (date != null && date.isUtc) {
        print("Util.prettyTime date is utc");
        date = date.toLocal(); // localized for display only
      }

      // Build pretty string
      try {
        String format = "";

        if (showMeridiem) {
          format = "a";
        } else if (showSeconds) {
          if (is24H)
            format = "HH:mm:ss";
          else
            format = "hh:mm:ss a";
        } else {
          if (is24H)
            format = "HH:mm";
          else
            format = "hh:mm a";
        }

        print("Util.prettyTime format ${format}");

        if (date != null) {
          pretty = DateFormat(format).format(date);
        }
      } catch (e) {
        print(e.toString());
        // pretty = date.toIso8601String();
        pretty = "bad datetime format";
      }
    } catch (e) {
      pretty = "";
    }

    return pretty;
  }

  static String prettyConstant(String z) {
    String result;
    try {
      result = z;

      // Replace underscores with spaces
      result = result.replaceAll("_", " ");

      // Lowercase long streaks of capital letters
      result = result.replaceAllMapped(
          RegExp(r"([A-Z])([A-Z]+)"),
          (match) =>
              "${match.group(1)}${(match.group(2) ?? "").toLowerCase()}");

      // Put spaces between a lowercase letter followed by a capital letter
      result = result.replaceAllMapped(RegExp(r"([a-z])([A-Z])"),
          (match) => "${match.group(1)} ${match.group(2)}");
    } catch (e) {
      result = z;
      print(e.toString());
    }
    return result;
  }

  static String getOSCode() =>
      Platform.operatingSystem; //Platform.isIOS ? "ios" : "android";

  static Future<String?> getBuildVersion() async {
    String? _buildVersion = Util._buildVersion;
    try {
      if (_buildVersion == null) {
        Util._buildVersion = await PackageInfo.fromPlatform()
            .then((packageInfo) => packageInfo.version);
        _buildVersion = Util._buildVersion;
      }
    } catch (e) {
      _buildVersion = null;
    }
    return _buildVersion;
  }

  static Future<String?> getBuildNumber() async {
    String? _buildNumber = Util._buildNumber;
    try {
      if (_buildNumber == null) {
        Util._buildNumber = await PackageInfo.fromPlatform()
            .then((packageInfo) => packageInfo.buildNumber);
        _buildNumber = Util._buildNumber;
      }
    } catch (e) {
      _buildNumber = null;
    }
    return _buildNumber;
  }

  static String fileToBase64(File file) {
    List<int> bytes = file.readAsBytesSync();
    return base64Encode(bytes);
  }

  static String buildRandomString(int length) =>
      List<int>.generate(length, (i) => i + 1)
          .map((e) => String.fromCharCode(Util.getRandom().nextInt(57) + 65))
          .join();
}
