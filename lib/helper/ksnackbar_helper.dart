import 'package:app_core/helper/kglobals.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:flutter/material.dart';

enum SnackBarLevel { error, warning, success }

abstract class KSnackBarHelper {
  /// Display a standardized Snackbar
  static ScaffoldFeatureController show({
    required String text,
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
        key: kScaffoldKey,
        text: text ?? "An error occur",
        level: SnackBarLevel.error,
      );

  /// Show an error snackbar
  static ScaffoldFeatureController warning([String? text]) => show(
        key: kScaffoldKey,
        text: text ?? "Confirmed",
        level: SnackBarLevel.warning,
      );

  /// Show a success snackbar
  static ScaffoldFeatureController success([String? text]) => show(
        key: kScaffoldKey,
        text: text ?? "Success",
        level: SnackBarLevel.success,
      );

  /// Display generic success message
  static ScaffoldFeatureController fromResponse(BaseResponse response) =>
      (response.isSuccess ? success : error).call(response.prettyMessage);
}
