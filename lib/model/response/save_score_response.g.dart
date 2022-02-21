// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_score_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KSaveScoreResponse _$KSaveScoreResponseFromJson(Map<String, dynamic> json) =>
    KSaveScoreResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..gameScores = (json['gameScores'] as List<dynamic>?)
          ?.map((e) => KGameScore.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KSaveScoreResponseToJson(KSaveScoreResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull(
      'gameScores', instance.gameScores?.map((e) => e.toJson()).toList());
  return val;
}
