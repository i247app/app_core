// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kgame_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGameScore _$KGameScoreFromJson(Map<String, dynamic> json) => KGameScore()
  ..scoreID = json['scoreID'] as String?
  ..puid = json['puid'] as String?
  ..kunm = json['kunm'] as String?
  ..avatarURL = json['avatarURL'] as String?
  ..game = json['gameID'] as String?
  ..level = json['level'] as int?
  ..score = (json['score'] as num?)?.toDouble()
  ..scoreDate = zzz_str2Date(json['scoreDate'] as String?);

Map<String, dynamic> _$KGameScoreToJson(KGameScore instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('scoreID', instance.scoreID);
  writeNotNull('puid', instance.puid);
  writeNotNull('kunm', instance.kunm);
  writeNotNull('avatarURL', instance.avatarURL);
  writeNotNull('gameID', instance.game);
  writeNotNull('level', instance.level);
  writeNotNull('score', instance.score);
  writeNotNull('scoreDate', zzz_date2Str(instance.scoreDate));
  return val;
}
