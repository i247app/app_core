// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_heroes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KListHeroesResponse _$KListHeroesResponseFromJson(Map<String, dynamic> json) {
  return KListHeroesResponse()
    ..kstatus = zzz_parseInt(json['kstatus'] as String?)
    ..kmessage = json['kmessage'] as String?
    ..ktoken = json['ktoken'] as String?
    ..heroes = (json['heroes'] as List<dynamic>?)
        ?.map((e) => KHero.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$KListHeroesResponseToJson(
        KListHeroesResponse instance) =>
    <String, dynamic>{
      'kstatus': zzz_itoa(instance.kstatus),
      'kmessage': instance.kmessage,
      'ktoken': instance.ktoken,
      'heroes': instance.heroes,
    };
