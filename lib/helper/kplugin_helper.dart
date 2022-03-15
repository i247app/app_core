import 'dart:convert';

import 'package:flutter/services.dart';

abstract class KPluginHelper {
  static const MethodChannel _channel = MethodChannel('chaoapp.com/default');

  static Future createAndroidNotificationChannel({ MethodChannel? channel }) async {
    if (channel == null) {
      channel = _channel;
    }
    // return Future.value(null);
    try {
      return channel.invokeMethod(
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

  static Future<bool?> biometricAuth(String? reason, { MethodChannel? channel }) async {
    if (channel == null) {
      channel = _channel;
    }
    try {
      final result = await channel.invokeMethod(
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
    } catch(e) {
      print(e);
    }
  }
}
