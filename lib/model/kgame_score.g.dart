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

Map<String, dynamic> _$KGameScoreToJson(KGameScore instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('puid', instance.puid);
  writeNotNull('kunm', instance.kunm);
  writeNotNull('avatar', instance.avatarURL);
  writeNotNull('gameID', instance.game);
  writeNotNull('level', instance.level);
  writeNotNull('ranking', instance.ranking);
  writeNotNull('rankDate', zzz_date2Str(instance.rankDate));
  writeNotNull('score', instance.score);
  writeNotNull('scoreType', instance.scoreType);
  writeNotNull('time', instance.time);
  writeNotNull('point', instance.point);
  writeNotNull('scoreDate', zzz_date2Str(instance.scoreDate));
  writeNotNull('gameAppID', instance.gameAppID);
  writeNotNull('language', instance.language);
  writeNotNull('topic', instance.topic);
  return val;
}
