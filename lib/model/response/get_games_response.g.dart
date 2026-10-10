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

Map<String, dynamic> _$KGetGamesResponseToJson(KGetGamesResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('games', instance.games?.map((e) => e.toJson()).toList());
  return val;
}
