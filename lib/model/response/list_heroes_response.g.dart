// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_heroes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KListHeroesResponse _$KListHeroesResponseFromJson(Map<String, dynamic> json) =>
    KListHeroesResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..heroes = (json['heroes'] as List<dynamic>?)
          ?.map((e) => KHero.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KListHeroesResponseToJson(
        KListHeroesResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.heroes?.map((e) => e.toJson()).toList() case final value?)
        'heroes': value,
    };
