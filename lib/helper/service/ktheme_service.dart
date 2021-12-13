import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

abstract class KThemeService {
  static final String _storageKey = "cached_theme_mode";
  static late final _getStorage = GetStorage();

  static ThemeMode getThemeMode() {
    final cachedThemeMode = _getStorage.read(_storageKey) ?? "";
    // print("cachedThemeMode - $cachedThemeMode");

    final ThemeMode theMode;
    switch (cachedThemeMode) {
      case 'ThemeMode.light':
        theMode = ThemeMode.light;
        break;
      case 'ThemeMode.dark':
        theMode = ThemeMode.dark;
        break;
      case 'ThemeMode.system':
      default:
        theMode = ThemeMode.system;
        break;
    }
    return theMode;
  }

  static bool isDarkMode() {
    try {
      return Theme.of(kNavigatorKey.currentContext!).brightness ==
          Brightness.dark;
      // return getThemeMode() == ThemeMode.dark;
    } catch (e) {
      print("=>>> ${e.toString()}");
      return false;
    }
  }

  static void setThemeMode(ThemeMode mode) {
    _getStorage
      ..write(_storageKey, mode.toString())
      ..save();
    KRebuildHelper.forceRebuild();
  }
}
