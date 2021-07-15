import 'package:app_core/header/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class AppCoreToastHelper {
  /// Display a toast with standardized appearance
  static show(
    String msg, {
    Color? textColor,
    Color? backgroundColor,
    Toast? toastLength,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength ?? Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: textColor ?? Styles.extraDarkGrey,
      fontSize: 16.0,
      backgroundColor:
      backgroundColor ?? Styles.extraLightGrey.withAlpha(0xBB),
    );
  }

  /// Display generic error message
  static Future<bool?> error([String? message]) async =>
      show(message ?? "An error occurred", textColor: Styles.colorError);

  /// Display generic success message
  static Future<bool?> success([String? message]) async =>
      show(message ?? "Success", textColor: Styles.black);
}
