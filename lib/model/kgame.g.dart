// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kgame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGame _$KGameFromJson(Map<String, dynamic> json) => KGame()
  ..gameID = json['gameID'] as String?
  ..gameCode = json['gameCode'] as String?
  ..title = json['title'] as String?
  ..subtitle = json['subtitle'] as String?
  ..text = json['text'] as String?
  ..cat = json['cat'] as String?
  ..level = json['level'] as String?
  ..qnas = (json['qnas'] as List<dynamic>?)
      ?.map((e) => KQNA.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$KGameToJson(KGame instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('gameID', instance.gameID);
  writeNotNull('gameCode', instance.gameCode);
  writeNotNull('title', instance.title);
  writeNotNull('subtitle', instance.subtitle);
  writeNotNull('text', instance.text);
  writeNotNull('cat', instance.cat);
  writeNotNull('level', instance.level);
  writeNotNull('qnas', instance.qnas?.map((e) => e.toJson()).toList());
  return val;
}
