import 'dart:convert';
import 'dart:io';

import 'package:app_core/helper/pref_helper.dart';
import 'package:app_core/helper/util.dart';
import 'package:device_info/device_info.dart';

abstract class AppCoreDeviceIDHelper {
  static const String PREFS_KEY = "backup_device_id";

  static Future<String> get deviceID async {
    String id = '';
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
        id = deviceInfo.androidId;
      } else if (Platform.isIOS) {
        IosDeviceInfo deviceInfo = await DeviceInfoPlugin().iosInfo;
        id = deviceInfo.identifierForVendor;
      }
    } catch (e) {}

    if (id == '') {
      id = await _getFallbackID();
    }

    return id;
  }

  static Future<String> _getFallbackID() async {
    String? id = await AppCorePrefHelper.get(PREFS_KEY);
    if (id == null) {
      id = base64Encode(
          List<int>.generate(32, (i) => AppCoreUtil.getRandom().nextInt(256)));
      AppCorePrefHelper.put(PREFS_KEY, id);
    }
    return id;
  }
}
