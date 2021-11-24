import 'dart:convert';

import 'package:app_core/helper/khost_config.dart';
import 'package:app_core/helper/klocale_helper.dart';
import 'package:flutter/services.dart';

class KLingoDictionary {
  final String language;
  final String dictFilepath;

  KLingoDictionary({required this.language, required this.dictFilepath});
}

class KLingo {
  final List<KLingoDictionary> dictionaries;
  final String fallbackLanguage;

  final Map<String, Map<String, String>> _wordMaps = {};

  String get _currentLang => KLocaleHelper.currentLocale.language;

  KLingo(this.dictionaries, {required this.fallbackLanguage});

  Future load() async {
    try {
      // // Filename
      // final enLangFile = Assets.I18N_EN;
      // final viLangFile = Assets.I18N_VN;
      // final langFile = _currentLocale.language == KLocaleHelper.LANGUAGE_EN
      //     ? Assets.I18N_EN
      //     : Assets.I18N_VN;
      _wordMaps.clear();

      // Load JSON
      for (KLingoDictionary dict in dictionaries) {
        final dictRawString = await rootBundle.loadString(dict.dictFilepath);
        final Map<String, dynamic> dictMap = json.decode(dictRawString);
        _wordMaps[dict.language] = dictMap.cast<String, String>();
      }
      // final enJsonString = await rootBundle.loadString(enLangFile);
      // final viJsonString = await rootBundle.loadString(viLangFile);
      // final jsonString = await rootBundle.loadString(langFile);
      // final Map<String, dynamic> enJsonMap = json.decode(enJsonString);
      // final Map<String, dynamic> viJsonMap = json.decode(viJsonString);
      // final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // final Map<String, dynamic> masterJsonMap = {};
      // masterJsonMap.addAll(jsonMap);
      // enJsonMap.forEach((k, v) => masterJsonMap.putIfAbsent(k, () => v));
      // viJsonMap.forEach((k, v) => masterJsonMap.putIfAbsent(k, () => v));

      // _localizationMap = masterJsonMap
      //     .map((k, v) => MapEntry<String, String>(k, v.toString()));

      print("KLingo - Loaded!");
    } catch (e) {
      print("KLingo LOAD EXCEPTION");
      print(e.toString());
    }
  }

  String yak(String name, {String? alt}) {
    String? v;
    try {
      final defaultWordMap = _wordMaps[_currentLang]!;
      final fallbackWordMap = _wordMaps[fallbackLanguage]!;
      if (defaultWordMap.containsKey(name)) {
        // First check in default dictionary
        v = defaultWordMap[name];
      } else if (fallbackWordMap.containsKey(name)) {
        // Then check in fallback dictionary
        v = fallbackWordMap[name];
      } else {
        // Otherwise loop through all available word maps
        for (final wordMapKey in _wordMaps.keys) {
          final wordMap = _wordMaps[wordMapKey]!;
          if (wordMap.containsKey(name)) {
            v = wordMap[name];
            break;
          }
        }
      }
    } catch (e) {
      print(e.toString());
      v = null;
    }

    // debug - will print everytime yak() is called
    // print("KLingo [${_currentLocale.language}] $name -> $v");

    String backupValue;
    try {
      backupValue = alt ?? (KHostConfig.isReleaseMode ? "" : "## $name ##");
    } catch (e) {
      backupValue = "";
    }

    return v ?? backupValue;
  }
}
