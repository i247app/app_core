import 'package:app_core/header/kold_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'khost_config.dart';

abstract class KToastHelper {
  /// Display a toast with standardized appearance
  static show(
    String msg, {
    Color? textColor,
    Color? backgroundColor,
    Toast? toastLength,
  }) {
    try {
      if (KHostConfig.isReleaseMode) {
        return Future.value(false);
      } else {
        return Fluttertoast.showToast(
          msg: msg,
          toastLength: toastLength ?? Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: textColor ?? KOldStyles.extraDarkGrey,
          fontSize: 16.0,
          backgroundColor:
              backgroundColor ?? KOldStyles.extraLightGrey.withAlpha(0xBB),
        );
      }
    } catch (e) {
      return Future.value(false);
    }
  }

  /// Display generic error message
  static Future<bool?> error([String? message]) async =>
      show(message ?? "An error occurred", textColor: KOldStyles.colorError);

  /// Display generic success message
  static Future<bool?> success([String? message]) async =>
      show(message ?? "Success", textColor: KOldStyles.black);
}
