// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_scores_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGetGameScoresResponse _$KGetGameScoresResponseFromJson(
        Map<String, dynamic> json) =>
    KGetGameScoresResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..scores = (json['gameScores'] as List<dynamic>?)
          ?.map((e) => KGameScore.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KGetGameScoresResponseToJson(
    KGetGameScoresResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('gameScores', instance.scores?.map((e) => e.toJson()).toList());
  return val;
}
