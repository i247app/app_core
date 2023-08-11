import 'package:app_core/helper/kglobals.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:flutter/material.dart';

enum SnackBarLevel { error, warning, success }

abstract class KSnackBarHelper {
  /// Display a standardized Snackbar
  static ScaffoldFeatureController show(
    String text, {
    GlobalKey<ScaffoldState>? key,
    SnackBarLevel level = SnackBarLevel.success,
    @Deprecated(
        "Use level enum instead SnackBarLevel.[success, warning, error]")
    bool? isSuccess,
  }) =>
      ScaffoldMessenger.of((key ?? kNavigatorKey).currentContext!).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: isSuccess == null
              ? levelToColor(level)
              : levelToColor(
                  isSuccess ? SnackBarLevel.success : SnackBarLevel.error),
        ),
      );

  static Color levelToColor(SnackBarLevel level) {
    switch (level) {
      case SnackBarLevel.error:
        return Colors.red;
      case SnackBarLevel.warning:
        return Colors.orange;
      case SnackBarLevel.success:
        return Colors.green;
    }
  }

  /// Hide current SnackBar
  static hide(GlobalKey<ScaffoldState>? key) =>
      ScaffoldMessenger.of((key ?? kNavigatorKey).currentContext!)
          .hideCurrentSnackBar();

  /// Show an error snackbar
  static ScaffoldFeatureController error([String? text]) => show(
        text ?? "An error occur",
        level: SnackBarLevel.error,
        key: kScaffoldKey,
      );

  /// Show an error snackbar
  static ScaffoldFeatureController warning([String? text]) => show(
        text ?? "Confirmed",
        level: SnackBarLevel.warning,
        key: kScaffoldKey,
      );

  /// Show a success snackbar
  static ScaffoldFeatureController success([String? text]) => show(
        text ?? "Success",
        level: SnackBarLevel.success,
        key: kScaffoldKey,
      );

  /// Display generic success message
  static ScaffoldFeatureController fromResponse(BaseResponse response) {
    ScaffoldFeatureController Function([String?]) func;
    if (response.isSuccess) {
      func = success;
    } else if (response.isNoData) {
      func = warning;
    } else {
      func = error;
    }
    return func.call(response.prettyMessage);
  }
}
