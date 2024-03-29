import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:app_core/helper/kpref_helper.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:device_info_plus/device_info_plus.dart';

abstract class KDeviceIDHelper {
  static const String PREFS_KEY = "backup_device_id";

  static Future<String> get deviceID async {
    String id = '';
    try {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        id = await androidIdPlugin.getId() ?? '';
      } else if (Platform.isIOS) {
        IosDeviceInfo deviceInfo = await DeviceInfoPlugin().iosInfo;
        id = deviceInfo.identifierForVendor ?? '';
      }
    } catch (e) {}

    if (id == '') {
      id = await _getFallbackID();
    }

    return id;
  }

  static Future<String> _getFallbackID() async {
    String? id = await KPrefHelper.get<String>(PREFS_KEY);
    if (id == null) {
      id = base64Encode(
          List<int>.generate(32, (i) => KUtil.getRandom().nextInt(256)));
      KPrefHelper.put(PREFS_KEY, id);
    }
    return id;
  }
}
