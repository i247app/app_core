import 'dart:async';
import 'dart:convert';

import 'package:app_core/helper/khost_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class KPrefHelper {
  static const String TAG = 'KPrefHelper';

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

  static late final _PrefAdapter _instance = _PrefAdapter();

  static bool get isDebugMode => !KHostConfig.isReleaseMode;

  static Future<String?> put(String key, dynamic value) async {
    final original = await _instance.get(key);
    await _instance.put(key, jsonEncode(value));
    if (isDebugMode) print('$TAG PUT $key = $value');
    return original;
  }

  static Future<T?> get<T>(String key) async {
    final String? raw = await _instance.get(key);
    if (isDebugMode) print('$TAG GET $key -> ${raw.runtimeType}:$raw');
    dynamic result;
    try {
      result = raw == null ? null : jsonDecode(raw);
    } catch (_) {}
    return result as T?;
  }

  static Future<List<T>?> getList<T>(String key) async =>
      get<List>(key).then((r) => r?.cast<T>());

  static Future<T?> remove<T>(String key) async {
    final String? rawOriginal = await _instance.get(key);
    await _instance.remove(key);
    if (isDebugMode) print('$TAG REMOVE $key');
    dynamic result;
    try {
      result = rawOriginal == null ? null : jsonDecode(rawOriginal);
    } catch (_) {}
    return result as T?;
  }
}

/// Helper class to intelligently switch between plugins
class _PrefAdapter {
  static const String SS_PREFIX = "_ss_";

  late final _plugin = FlutterSecureStorage();

  Future<void> put(String key, String? value) async {
    await _plugin.write(key: "$SS_PREFIX/$key", value: value);
  }

  Future<String?> get(String key) async {
    final String? result = await _plugin.read(key: "$SS_PREFIX/$key");
    return result;
  }

  Future<void> remove(String key) async {
    await _plugin.delete(key: "$SS_PREFIX/$key");
  }
}
