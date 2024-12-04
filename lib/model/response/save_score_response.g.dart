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

Map<String, dynamic> _$KSaveScoreResponseToJson(KSaveScoreResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.gameScores?.map((e) => e.toJson()).toList()
          case final value?)
        'gameScores': value,
    };
