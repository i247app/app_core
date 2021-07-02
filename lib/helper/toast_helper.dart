import 'package:app_core/helper/host_config.dart';
import 'package:app_core/header/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class ToastHelper {
  /// Display a toast with standardized appearance
  static Future<bool?> show(
    String message, {
    Color? textColor,
    Color? backgroundColor,
    Toast? toastLength,
  }) {
    try {
      if (HostConfig.isReleaseMode) {
        return Future.value(false);
      } else {
        return Fluttertoast.showToast(
          msg: message,
          toastLength: toastLength ?? Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: textColor ?? Styles.extraDarkGrey,
          fontSize: 16.0,
          backgroundColor:
              backgroundColor ?? Styles.extraLightGrey.withAlpha(0xBB),
        );
      }
    } catch (e) {
      return Future.value(false);
    }
  }

  /// Display generic error message
  static Future<bool?> error([String? message]) async =>
      show(message ?? "An error occurred", textColor: Styles.colorError);

  /// Display generic success message
  static Future<bool?> success([String? message]) async =>
      show(message ?? "Success", textColor: Styles.black);
}
