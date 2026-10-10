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

Map<String, dynamic> _$KListHeroesResponseToJson(KListHeroesResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('heroes', instance.heroes?.map((e) => e.toJson()).toList());
  return val;
}
