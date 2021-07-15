import 'package:flutter/material.dart';

abstract class DateHelper {
  static const String AM = "AM";
  static const String PM = "PM";

  static int diffMillis(DateTime dt1, DateTime dt2) =>
      dt1.difference(dt2).inMilliseconds;

  static DateTime copy(
    DateTime date, {
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? date.year,
      month ?? date.month,
      day ?? date.day,
      hour ?? date.hour,
      minute ?? date.minute,
      second ?? date.second,
      millisecond ?? date.millisecond,
      microsecond ?? date.microsecond,
    );
  }

  // expecting a utc DateTime String from server
  static DateTime? from20FSP(String z, {bool isUTC = true}) {
    try {
      // yyyyMMddHHmmss.SSSSSS
      String year = z.substring(0, 4);
      String month = z.substring(4, 6);
      String date = z.substring(6, 8);
      String hour = z.substring(8, 10);
      String min = z.substring(10, 12);
      String sec = z.substring(12, 14);
      return isUTC
          ? DateTime.utc(
              int.parse(year), // YEAR
              int.parse(month), // MONTH
              int.parse(date), // DATE
              int.parse(hour), // HOUR
              int.parse(min), // MINUTE
              int.parse(sec), // SECOND
            )
          : DateTime(
              int.parse(year), // YEAR
              int.parse(month), // MONTH
              int.parse(date), // DATE
              int.parse(hour), // HOUR
              int.parse(min), // MINUTE
              int.parse(sec), // SECOND
            );
    } catch (e) {
      return null;
    }
  }

  static String? to20FSP(DateTime? date, {bool toUTC = true}) {
    try {
      date ??= DateTime.now();
      if (toUTC) date = date.toUtc();
      String convertD = date.toString();
      String year = convertD.substring(0, 4);
      String month = convertD.substring(5, 7);
      String monthDate = convertD.substring(8, 10);
      String hour = convertD.substring(11, 13);
      String min = convertD.substring(14, 16);
      String sec = convertD.substring(17, 19);
      String meSec = convertD.substring(20);
      String vToString =
          year + month + monthDate + hour + min + sec + "." + meSec;
      vToString = vToString.replaceAll(RegExp(r"[a-zA-Z]"), "");
      // print("vToString : $vToString");
      return vToString;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<DateTime?> showDateDialog(
    BuildContext context, {
    DateTime? firstDate,
    DateTime? initialDate,
    DateTime? lastDate,
  }) async {
    // Get the date
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate!,
      firstDate: firstDate!,
      lastDate: lastDate!,
    );
    if (date == null) return null;

    // Get the time
    final TimeOfDay? tod = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (tod == null) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      tod.hour,
      tod.minute,
    );
  }

  static String? getMeridiem(DateTime date) =>
      date.hour >= 12 && date.hour < 24 ? PM : AM;
}
