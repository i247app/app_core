import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kdate_helper.dart';
import 'package:app_core/helper/kdevice_id_helper.dart';
import 'package:app_core/helper/khost_config.dart';
import 'package:app_core/helper/klocale_helper.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/helper/ktablet_detector.dart';
import 'package:app_core/model/kgig_address.dart';
import 'package:app_core/model/krole.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/ui/wallet/wallet_transfer.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:timeago/timeago.dart' as timeago;

abstract class KUtil {
  static Random? _random = Random();
  static String? _buildVersion;
  static String? _buildNumber;
  static List<String> ignoreAddressWords = [
    "ward",
    "district",
    "Ward",
    "District",
    "Phường",
    "Quận"
  ];
  static String get buildVersion => KUtil._buildVersion ?? "";

  static String get buildNumber => KUtil._buildNumber ?? "";

  static Future<String> getDeviceID() async => KDeviceIDHelper.deviceID;

  static String getTimezoneName() {
    final DateTime now = DateTime.now();
    return now.timeZoneName;
  }

  // Get timezone offet with hours and minutes format hh:mm
  static String getTimezonOffset() {
    final DateTime now = DateTime.now();
    final offsetString = now.timeZoneOffset.toString();
    final parts = offsetString.split(":");
    parts.removeLast();
    return parts.join(":");
  }

  static Future<String> getDeviceBrand() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return Platform.isAndroid ? (await deviceInfo.androidInfo).brand : 'Apple';
  }

  static Future<String> getDeviceModel() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return Platform.isAndroid
        ? (await deviceInfo.androidInfo).model
        : (await deviceInfo.iosInfo).name;
  }

  static Future<String> getDeviceVersion() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return Platform.isAndroid
        ? (await deviceInfo.androidInfo).version.release
        : (await deviceInfo.iosInfo).systemVersion;
  }

  static Future<String> getDeviceName() async {
    final brand = await getDeviceBrand();
    final model = await getDeviceModel();
    final version = await getDeviceVersion();
    return "$brand-$model $version";
  }

  static Future<bool> isPhysicalDevice() async =>
      (await DeviceInfoPlugin().androidInfo).isPhysicalDevice;

  static Future<bool> isEmulator() async => isPhysicalDevice().then((b) => !b);

  static String localeName() => KLocaleHelper.localeName;

  static String getPlatformCode() => Platform.operatingSystem;

  static Random getRandom() =>
      _random ??= Random(DateTime.now().millisecondsSinceEpoch);

  static Color getRandomColor() => Color.fromRGBO(getRandom().nextInt(0xFF),
      getRandom().nextInt(0xFF), getRandom().nextInt(0xFF), 0x01);

  static Color colorFromString(String z) {
    int n = 0;
    for (int i = 0; i < z.length; i++) n += z.codeUnitAt(i);
    return Colors.primaries[n % Colors.primaries.length];
  }

  static String prettyJSON(final data) {
    final encoder = JsonEncoder.withIndent("     ");
    return encoder.convert(data is String ? jsonDecode(data) : data);
  }

  static bool get isDebug =>
      !KHostConfig.isReleaseMode &&
      !KHostConfig.isProductionHost(KHostConfig.defaultHost);

  static Future<bool> isTabletDevice(BuildContext context) async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return KTabletDetector.isTablet(MediaQuery.of(context)) ||
        (Platform.isIOS &&
            (await deviceInfo.iosInfo).name.toLowerCase().contains("ipad"));
  }

  static String prettyXFRDescription({String? lineType, String? xfrType}) {
    String z;
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
        z = "";
        break;
    }
    return z;
  }

  // static String? prettyAddressLine(String addressLine1, String addressLine2, String ward, String district) {
  static String? prettyGigAddressLine(KGigAddress address) {
    String? z;

    if (!KStringHelper.isEmpty(address.addressLine1)) {
      z = (z ?? "") + address.addressLine1!;
    }

    if (!KStringHelper.isEmpty(address.addressLine2)) {
      z = (z ?? "") + ", ${address.addressLine2}";
    }

    if (!KStringHelper.isEmpty(address.ward)) {
      z = (z ?? "") + ", ${address.ward}";
    }

    if (!KStringHelper.isEmpty(address.district)) {
      z = (z ?? "") + ", ${address.district}";
    }

    return z;
  }

  static String maskedFone(String fone) {
    if (fone.length <= 4) {
      return fone.replaceAll(RegExp(r'.'), 'x');
    } else {
      return fone.replaceAll(RegExp(r'.'), 'x').substring(0, fone.length - 4) +
          fone.substring(fone.length - 4);
    }
  }

  static String prettyDistance({double distanceInMeters = 0}) {
    if (distanceInMeters < 1000) {
      int meters = distanceInMeters.ceil();
      return "${meters}m";
    }

    double distanceInKiloMeters = distanceInMeters / 1000;
    double roundDistanceInKM =
        double.parse((distanceInKiloMeters).toStringAsFixed(1));
    return "${roundDistanceInKM}km";
  }

  static String prettyFone({String foneCode = "", String number = ""}) {
    foneCode = foneCode.replaceAll("+", "");
    final String prefix = foneCode.isNotEmpty ? "+$foneCode" : "";
    final String numberWithoutLeadingZero =
        number.replaceAll(RegExp(r'^0+'), '');
    return prefix.isEmpty ? number : "$prefix$numberWithoutLeadingZero";
  }

  // TODO VN - last, middle first else first middle last
  static String? prettyName({String? fnm, String? mnm, String? lnm}) {
    if (fnm == null && mnm == null && lnm == null) return null;

    String? title;
    try {
      title = KSessionData.me!.countryCode == KLocaleHelper.COUNTRY_VN
          ? KStringHelper.capitalize(lnm ?? "")
          : KStringHelper.capitalize(fnm ?? "");

      if (!KStringHelper.isEmpty(mnm))
        title += " " + KStringHelper.capitalize(mnm ?? "");
      if (!KStringHelper.isEmpty(lnm))
        title += " " +
            (KSessionData.me!.countryCode == KLocaleHelper.COUNTRY_VN
                ? KStringHelper.capitalize(fnm ?? "")
                : KStringHelper.capitalize(lnm ?? ""));
    } catch (e) {
      title = null;
    }
    if (title == "") {
      return null;
    }
    return title;
  }

  static String? chatDisplayName({
    String? kunm = "",
    String? fnm = "",
    String? mnm = "",
    String? lnm = "",
  }) {
    String? title;

    try {
      title = "";

      if (!KStringHelper.isEmpty(kunm)) title += "@$kunm";
      if (!KStringHelper.isEmpty(fnm))
        title += " " + KStringHelper.capitalize(fnm ?? "");
      if (!KStringHelper.isEmpty(mnm))
        title += " " + KStringHelper.capitalize(mnm ?? "");
      if (!KStringHelper.isEmpty(lnm))
        title += " " + KStringHelper.capitalize(lnm ?? "");
    } catch (e) {
      title = null;
    }

    return title;
  }

  // Anna L H. - name with last initial
  static String privacyName({
    String fnm = "",
    String mnm = "",
    String lnm = "",
  }) {
    String title = "";
    try {
      title = fnm;
      if (!KStringHelper.isEmpty(mnm))
        title += " " + KStringHelper.toInitials(name: mnm);

      if (!KStringHelper.isEmpty(lnm))
        title += " " + KStringHelper.toInitials(name: lnm);
    } catch (e) {
      title = "";
      print(e);
    }

    return title;
  }

  static String ampDisplayName({
    String? bnm = "",
    String fnm = "",
    String mnm = "",
    String lnm = "",
    String? fone = "",
  }) {
    return bnm ??
        (KUtil.privacyName(fnm: fnm, mnm: mnm, lnm: lnm).isNotEmpty
            ? KUtil.privacyName(fnm: fnm, mnm: mnm, lnm: lnm)
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

  // Remove all string match with ignoreStrings and trim it
  static String removeIgnoreStrings(String str, List<String> ignoreStrings) {
    for (String ignoreString in ignoreStrings) {
      str = str.replaceAll(RegExp(ignoreString), "");
    }
    return str.trim();
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
    bool acceptZero = true,
    bool tokenToRight = false,
  }) {
    if (amount == null) return "";
    double dAmount = double.tryParse(amount) ?? 0;
    String pretty = "0";
    String uppercaseToken = tokenName?.toUpperCase() ?? "";
    try {
      switch (uppercaseToken) {
        case "USD":
          if (useCurrencyName) {
            if (tokenToRight) {
              pretty = NumberFormat.currency(locale: "en").format(dAmount);
              pretty = pretty.replaceAll("USD", "");
              pretty = "$pretty USD";
            } else {
              pretty = NumberFormat.currency(locale: "en").format(dAmount);
            }
          } // USD1,234.56 or USD1,234.00
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
        default: // default locale most likely en or vi
          // 1.234,56 or 1.234
          if (useCurrencyName) {
            pretty = NumberFormat("#,###.## ${uppercaseToken}").format(dAmount);
          } else {
            pretty = NumberFormat("#,###.##").format(dAmount);
          }

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
    if ((number ?? "").isEmpty) return null;

    String pretty;
    try {
      switch (tokenName) {
        case "VND":
          pretty =
              NumberFormat("###.##", "vi_VN").format(double.tryParse(number!));
          break;
        case "USD":
          pretty =
              NumberFormat("##0.00", "en_US").format(double.tryParse(number!));
          break;
        default:
          pretty = NumberFormat("###.##").format(double.tryParse(number!));
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
      if (fractionalPart.isNotEmpty) z = z + "." + fractionalPart;
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
          date = KDateHelper.copy(rawDate);
          break;
        case String:
        default:
          date = KDateHelper.from20FSP(rawDate.toString());
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

  static String formatDate(
    dynamic rawDate, {
    String format = "MM/yyyy",
  }) {
    String pretty = "";

    try {
      // Convert input to DateTime object
      DateTime? date;
      switch (rawDate.runtimeType) {
        case DateTime:
          date = KDateHelper.copy(rawDate);
          break;
        case String:
        default:
          date = KDateHelper.from20FSP(rawDate.toString(), isUTC: false);
          break;
      }

      // if (date != null && date.isUtc) {
      //   print("a date is utc");
      //   date = date.toLocal(); // localized for display only
      // }
      date = date?.toLocal();

      // Build pretty string
      try {
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
  static String prettyDate(
    dynamic rawDate, {
    bool showTime = false,
    bool abbreviate = false,
    bool is24H = true,
    String format = "yyyy-MM-dd",
  }) {
    String pretty = "";

    try {
      // Convert input to DateTime object
      DateTime? date;
      switch (rawDate.runtimeType) {
        case DateTime:
          date = KDateHelper.copy(rawDate);
          break;
        case String:
        default:
          date = KDateHelper.from20FSP(rawDate.toString(), isUTC: false);
          break;
      }

      // if (date != null && date.isUtc) {
      //   print("a date is utc");
      //   date = date.toLocal(); // localized for display only
      // }
      date = date?.toLocal();

      // Build pretty string
      try {
        if (abbreviate) {
          format = "E, MMM dd";
        } else {
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
          date = KDateHelper.copy(rawDate);
          break;
        case String:
        default:
          date = KDateHelper.from20FSP(rawDate.toString());
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

        print("Util.prettyTime format $format");

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

  static String prettyDuration(Duration? d) {
    if (d == null) return "";
    final hour = d.inHours;
    d -= Duration(hours: hour);
    final mins = d.inMinutes;
    d -= Duration(minutes: mins);
    final secs = d.inSeconds;
    d -= Duration(seconds: secs);

    String str = "";
    if (hour > 0) str = "$hour hours";
    if (mins > 0) str = "$str $mins mins";
    if (str.isEmpty) str = "$str ${secs}s";
    return str.trim();
  }

  /// Returns a string in the format hh:mm:ss
  static String prettyStopwatch(Duration duration) {
    final int h = duration.inHours % 24;
    final int m = duration.inMinutes % 60;
    final int s = duration.inSeconds % 60;

    String prettyElapsed = "";
    // Hours
    if (h > 0) prettyElapsed = "${h.toString().padLeft(2, '0')}";
    // Minutes
    if (KStringHelper.isExist(prettyElapsed)) prettyElapsed = "$prettyElapsed:";
    prettyElapsed = "$prettyElapsed${m.toString().padLeft(2, '0')}";
    // Seconds
    if (KStringHelper.isExist(prettyElapsed)) prettyElapsed = "$prettyElapsed:";
    prettyElapsed = "$prettyElapsed${s.toString().padLeft(2, '0')}";

    return prettyElapsed;
  }

  /// Returns a string in the format hh:mm:ss.
  static String prettyStopwatchWithFraction(Duration duration) {
    final int h = duration.inHours % 24;
    final int m = duration.inMinutes % 60;
    final int s = duration.inSeconds % 60;
    final int f = duration.inMilliseconds % 1000;
// print(f);
    String prettyElapsed = "";
    // Hours
    if (h > 0) prettyElapsed = "${h.toString().padLeft(2, '0')}";
    // Minutes
    if (KStringHelper.isExist(prettyElapsed)) prettyElapsed = "$prettyElapsed:";
    prettyElapsed = "$prettyElapsed${m.toString().padLeft(2, '0')}";
    // Seconds
    if (KStringHelper.isExist(prettyElapsed)) prettyElapsed = "$prettyElapsed:";
    prettyElapsed = "$prettyElapsed${s.toString().padLeft(2, '0')}";
    //
    if (KStringHelper.isExist(prettyElapsed)) prettyElapsed = "$prettyElapsed.";
    prettyElapsed = "$prettyElapsed${f.toString().padLeft(3, '0')}";

    return prettyElapsed;
  }

  static String getOSCode() =>
      Platform.operatingSystem; //Platform.isIOS ? "ios" : "android";

  static String getPushTokenMode() => isDebug ? "dvl" : "prd";

  static Future<String?> getBuildVersion() async {
    String? _buildVersion = KUtil._buildVersion;
    try {
      if (_buildVersion == null) {
        KUtil._buildVersion = await PackageInfo.fromPlatform()
            .then((packageInfo) => packageInfo.version);
        _buildVersion = KUtil._buildVersion;
      }
    } catch (e) {
      _buildVersion = null;
    }
    return _buildVersion;
  }

  static Future<String?> getBuildNumber() async {
    String? _buildNumber = KUtil._buildNumber;
    try {
      if (_buildNumber == null) {
        KUtil._buildNumber = await PackageInfo.fromPlatform()
            .then((packageInfo) => packageInfo.buildNumber);
        _buildNumber = KUtil._buildNumber;
      }
    } catch (e) {
      _buildNumber = null;
    }
    return _buildNumber;
  }

  static String fileToBase64(File file) {
    final List<int> bytes = file.readAsBytesSync();
    return base64Encode(bytes);
  }

  static String buildRandomString(int length) =>
      List<int>.generate(length, (i) => i + 1)
          .map((e) => String.fromCharCode(KUtil.getRandom().nextInt(57) + 65))
          .join();

  // TODO move somewhere else later
  // static Widget getPaymentScreen({
  //   required String? rcvPUID,
  //   required KRole? sndRole,
  //   required KTransferType transferType,
  //   required String tokenName,
  // }) =>
  //     KHostConfig.isReleaseMode
  //         ? WalletTransfer(
  //             transferType: transferType,
  //             tokenName: tokenName,
  //             rcvPUID: rcvPUID,
  //             sndRole: sndRole,
  //           )
  //         : WalletTransfer2(
  //             transferType: transferType,
  //             tokenName: tokenName,
  //             rcvPUID: rcvPUID,
  //             sndRole: sndRole,
  //           );

  static Widget getPaymentScreen({
    required KUser user,
    required String? rcvPUID,
    required KRole? sndRole,
    required KTransferType transferType,
    required String tokenName,
  }) =>
      WalletTransfer(
        user: user,
        transferType: transferType,
        tokenName: tokenName,
        rcvPUID: rcvPUID,
        sndRole: sndRole,
      );

  static String generateRandomString(int len) {
    var r = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
