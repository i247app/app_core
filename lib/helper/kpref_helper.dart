import 'dart:async';
import 'dart:convert';

import 'package:app_core/helper/khost_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class KPrefHelper {
  static const String TAG = 'SecureStorageHelper';

  static bool get isDebugMode => !KHostConfig.isReleaseMode;

  static const String KTOKEN = 'session_token';
  static const String PUSH_TOKEN = 'push_token';
  static const String LAST_LOGIN = 'last_login';
  static const String LAST_PASSWORD = 'last_password';
  static const String CACHED_POSITION = 'cached_position';
  static const String HAS_SHOWN_BG_LOCATION_NOTICE =
      'has_shown_bg_location_notice';
  static const String HAS_SHOWN_LOCATION_PICKER_INFO =
      'has_shown_location_picker_info';
  static const String PENDING_REM_ACTION = 'pending_rem_action';
  static const String CACHED_USER = 'cached_user';

  static _PrefAdapter? _prefAdapter;

  static _PrefAdapter get _instance => _prefAdapter ??= _PrefAdapter();

  static Future<String> put(String key, dynamic value) async {
    String original = await _instance.get(key);
    await _instance.put(key, jsonEncode(value));
    if (isDebugMode) print('$TAG PUT $key = $value');

    return original;
  }

  static Future<dynamic> get(String key, {defaultResult}) async {
    dynamic result = (await _instance.get(key)) ?? defaultResult;
    if (isDebugMode) print('$TAG GET $key -> $result');
    try {
      result = jsonDecode(result);
    } catch (e) {}
    return result;
  }

  static Future<String> remove(String key) async {
    String original = await _instance.get(key);
    await _instance.remove(key);
    if (isDebugMode) print('$TAG REMOVE $key');
    try {
      original = jsonDecode(original);
    } catch (e) {}
    return original;
  }
}

/// Helper class to intelligently switch between plugins
class _PrefAdapter {
  static const String SS_PREFIX = "_ss_";

  final plugin = new FlutterSecureStorage();

  Future put(String key, dynamic value) async {
    await plugin.write(key: "$SS_PREFIX/$key", value: value);
  }

  Future<dynamic> get(String key) async {
    String? result = await plugin.read(key: "$SS_PREFIX/$key");
    return result ?? "";
  }

  Future remove(String key) async {
    await plugin.delete(key: "$SS_PREFIX/$key");
  }
}
