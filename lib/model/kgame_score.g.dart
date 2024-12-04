// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kgame_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGameScore _$KGameScoreFromJson(Map<String, dynamic> json) => KGameScore()
  ..puid = json['puid'] as String?
  ..kunm = json['kunm'] as String?
  ..avatarURL = json['avatar'] as String?
  ..game = json['gameID'] as String?
  ..level = json['level'] as String?
  ..ranking = json['ranking'] as String?
  ..rankDate = zzz_str2Date(json['rankDate'] as String?)
  ..score = json['score'] as String?
  ..scoreType = json['scoreType'] as String?
  ..time = json['time'] as String?
  ..point = json['point'] as String?
  ..scoreDate = zzz_str2Date(json['scoreDate'] as String?)
  ..gameAppID = json['gameAppID'] as String?
  ..language = json['language'] as String?
  ..topic = json['topic'] as String?;

Map<String, dynamic> _$KGameScoreToJson(KGameScore instance) =>
    <String, dynamic>{
      if (instance.puid case final value?) 'puid': value,
      if (instance.kunm case final value?) 'kunm': value,
      if (instance.avatarURL case final value?) 'avatar': value,
      if (instance.game case final value?) 'gameID': value,
      if (instance.level case final value?) 'level': value,
      if (instance.ranking case final value?) 'ranking': value,
      if (zzz_date2Str(instance.rankDate) case final value?) 'rankDate': value,
      if (instance.score case final value?) 'score': value,
      if (instance.scoreType case final value?) 'scoreType': value,
      if (instance.time case final value?) 'time': value,
      if (instance.point case final value?) 'point': value,
      if (zzz_date2Str(instance.scoreDate) case final value?)
        'scoreDate': value,
      if (instance.gameAppID case final value?) 'gameAppID': value,
      if (instance.language case final value?) 'language': value,
      if (instance.topic case final value?) 'topic': value,
    };
