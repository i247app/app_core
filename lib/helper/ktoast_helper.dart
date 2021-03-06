import 'package:app_core/model/response/base_response.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:app_core/helper/khost_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
          textColor: textColor ?? KStyles.extraDarkGrey,
          fontSize: 16.0,
          backgroundColor:
              backgroundColor ?? KStyles.extraLightGrey.withAlpha(0xBB),
        );
      }
    } catch (e) {
      return Future.value(false);
    }
  }

  /// Display generic error message
  static Future<bool?> error([String? message]) async =>
      show(message ?? "An error occurred", textColor: KStyles.colorError);

  /// Display generic success message
  static Future<bool?> success([String? message]) async =>
      show(message ?? "Success", textColor: KStyles.black);

  /// Display generic success message
  static Future<bool?> fromBool(bool isSuccess) async =>
      (isSuccess ? success : error).call();

  /// Display generic success message
  static Future<bool?> fromResponse(BaseResponse response) async =>
      (response.isSuccess ? success : error).call(response.prettyMessage);
}
