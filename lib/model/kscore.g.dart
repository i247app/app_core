// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kscore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KScore _$KScoreFromJson(Map<String, dynamic> json) => KScore()
  ..scoreID = json['scoreID'] as String?
  ..user = json['user'] == null
      ? null
      : KUser.fromJson(json['user'] as Map<String, dynamic>)
  ..game = json['game'] as String?
  ..level = json['level'] as int?
  ..score = (json['score'] as num?)?.toDouble();

Map<String, dynamic> _$KScoreToJson(KScore instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('scoreID', instance.scoreID);
  writeNotNull('user', instance.user?.toJson());
  writeNotNull('game', instance.game);
  writeNotNull('level', instance.level);
  writeNotNull('score', instance.score);
  return val;
}
