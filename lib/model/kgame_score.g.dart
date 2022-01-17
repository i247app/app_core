// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kgame_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGameScore _$KGameScoreFromJson(Map<String, dynamic> json) => KGameScore()
  ..puid = json['puid'] as String?
  ..kunm = json['kunm'] as String?
  ..avatarURL = json['avatarURL'] as String?
  ..game = json['gameID'] as String?
  ..level = json['level'] as String?
  ..ranking = json['ranking'] as String?
  ..rankDate = zzz_str2Date(json['rankDate'] as String?)
  ..score = json['score'] as String?
  ..scoreDate = zzz_str2Date(json['scoreDate'] as String?);

Map<String, dynamic> _$KGameScoreToJson(KGameScore instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('puid', instance.puid);
  writeNotNull('kunm', instance.kunm);
  writeNotNull('avatarURL', instance.avatarURL);
  writeNotNull('gameID', instance.game);
  writeNotNull('level', instance.level);
  writeNotNull('ranking', instance.ranking);
  writeNotNull('rankDate', zzz_date2Str(instance.rankDate));
  writeNotNull('score', instance.score);
  writeNotNull('scoreDate', zzz_date2Str(instance.scoreDate));
  return val;
}
