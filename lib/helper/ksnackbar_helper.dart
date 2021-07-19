import 'package:app_core/header/kstyles.dart';
import 'package:app_core/helper/kglobals.dart';
import 'package:app_core/helper/kscaffold_key.dart';
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
  static error([String? text]) => show(
        key: kScaffoldKey,
        text: text ?? "An error occur",
        isSuccess: false,
      );

  /// Show a success snackbar
  static success([String? text]) => show(
        key: kScaffoldKey,
        text: text ?? "Success",
        isSuccess: true,
      );
}
