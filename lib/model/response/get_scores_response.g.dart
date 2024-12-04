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
      ..gameScores = (json['gameScores'] as List<dynamic>?)
          ?.map((e) => KGameScore.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KGetGameScoresResponseToJson(
        KGetGameScoresResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.gameScores?.map((e) => e.toJson()).toList()
          case final value?)
        'gameScores': value,
    };
