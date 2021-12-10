import 'package:app_core/helper/kglobals.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';

abstract class KSnackBarHelper {
  /// Display a standardized Snackbar
  static ScaffoldFeatureController show({
    required String text,
    GlobalKey<ScaffoldState>? key,
    bool isSuccess = true,
  }) =>
      ScaffoldMessenger.of((key ?? kNavigatorKey).currentContext!).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: isSuccess ? KStyles.colorBGYes : KStyles.colorBGNo,
        ),
      );

  /// Hide current SnackBar
  static hide(GlobalKey<ScaffoldState>? key) =>
      ScaffoldMessenger.of((key ?? kNavigatorKey).currentContext!)
          .hideCurrentSnackBar();

  /// Show an error snackbar
  static ScaffoldFeatureController error([String? text]) => show(
        key: kScaffoldKey,
        text: text ?? "An error occur",
        isSuccess: false,
      );

  /// Show a success snackbar
  static ScaffoldFeatureController success([String? text]) => show(
        key: kScaffoldKey,
        text: text ?? "Success",
        isSuccess: true,
      );

  /// Display generic success message
  static ScaffoldFeatureController fromResponse(BaseResponse response) =>
      (response.isSuccess ? success : error).call(response.prettyMessage);
}
