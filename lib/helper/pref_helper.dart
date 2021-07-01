import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class PrefHelper {
  static const String TAG = 'SecureStorageHelper';

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

  static _SecureStorageAdapter? _secureStorageAdapter;

  static Future<String> put(String key, dynamic value) async {
    final _SecureStorageAdapter storage = _getInstance();

    String original = await storage.get(key);
    await storage.put(key, jsonEncode(value));

    return original;
  }

  static Future<dynamic> get(String key, {defaultResult}) async {
    final _SecureStorageAdapter storage = _getInstance();

    dynamic result = (await storage.get(key)) ?? defaultResult;
    try {
      result = jsonDecode(result);
    } catch (e) {}
    return result;
  }

  static Future<String> remove(String key) async {
    final _SecureStorageAdapter storage = _getInstance();

    String original = await storage.get(key);
    await storage.remove(key);
    try {
      original = jsonDecode(original);
    } catch (e) {}
    return original;
  }

  static _getInstance() => _secureStorageAdapter ??= _SecureStorageAdapter();
}

/// Helper class to intelligently switch between plugins
class _SecureStorageAdapter {
  static const String SS_PREFIX = "_ss_";

  final plugin = FlutterSecureStorage();

  _SecureStorageAdapter() {
    setupPlugin();
  }

  void setupPlugin() async {}

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
