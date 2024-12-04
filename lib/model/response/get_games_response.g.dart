// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_games_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGetGamesResponse _$KGetGamesResponseFromJson(Map<String, dynamic> json) =>
    KGetGamesResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..games = (json['games'] as List<dynamic>?)
          ?.map((e) => KGame.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KGetGamesResponseToJson(KGetGamesResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.games?.map((e) => e.toJson()).toList() case final value?)
        'games': value,
    };
