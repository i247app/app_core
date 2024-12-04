// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kgame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGame _$KGameFromJson(Map<String, dynamic> json) => KGame()
  ..gameID = json['gameID'] as String?
  ..maxLevel = zzz_atoi(json['maxLevel'] as String?)
  ..gameAppID = json['gameAppID'] as String?
  ..gameCode = json['gameCode'] as String?
  ..title = json['title'] as String?
  ..subtitle = json['subtitle'] as String?
  ..text = json['text'] as String?
  ..cat = json['cat'] as String?
  ..topic = json['topic'] as String?
  ..language = json['language'] as String?
  ..level = json['level'] as String?
  ..mimeType = json['mimeType'] as String?
  ..qnas = (json['qnas'] as List<dynamic>?)
      ?.map((e) => KQNA.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$KGameToJson(KGame instance) => <String, dynamic>{
      if (instance.gameID case final value?) 'gameID': value,
      if (zzz_itoa(instance.maxLevel) case final value?) 'maxLevel': value,
      if (instance.gameAppID case final value?) 'gameAppID': value,
      if (instance.gameCode case final value?) 'gameCode': value,
      if (instance.title case final value?) 'title': value,
      if (instance.subtitle case final value?) 'subtitle': value,
      if (instance.text case final value?) 'text': value,
      if (instance.cat case final value?) 'cat': value,
      if (instance.topic case final value?) 'topic': value,
      if (instance.language case final value?) 'language': value,
      if (instance.level case final value?) 'level': value,
      if (instance.mimeType case final value?) 'mimeType': value,
      if (instance.qnas?.map((e) => e.toJson()).toList() case final value?)
        'qnas': value,
    };
