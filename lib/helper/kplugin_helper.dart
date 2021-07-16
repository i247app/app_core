import 'dart:convert';

import 'package:flutter/services.dart';

abstract class KPluginHelper {
  static const MethodChannel _channel = MethodChannel('chaoapp.com/default');

  static Future createAndroidNotificationChannel() async {
    // return Future.value(null);
    try {
      return _channel.invokeMethod(
        'create_notif_channel',
        {
          "id": "DEFAULT_NOTIF_CHANNEL",
          "name": "General",
          "description": "General notifications",
        },
      );
    } on PlatformException catch (e) {
      print(e);
      return Future.value(null);
    }
  }

  static Future<bool?> biometricAuth(String? reason) async {
    try {
      final result = await _channel.invokeMethod(
        'biometric_auth',
        {"prompt_title": reason ?? "Chao! Login"},
      );
      final trueValue = jsonDecode(jsonEncode(result));
      print("PluginHelper.biometricAuth result - $trueValue");
      if (trueValue) {
        // ToastHelper.success(result.toString());
        return true;
      } else {
        // ToastHelper.error(result.toString());
        return false;
      }
    } on PlatformException catch (e) {
      print("PluginHelper.biometricAuth EXCEPTION - $e");
      if (e.code == "2")
        return null;
      else
        return false;
    }
  }
}
