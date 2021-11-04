// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khero.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KHero _$KHeroFromJson(Map<String, dynamic> json) {
  return KHero()
    ..id = json['id'] as String?
    ..puid = json['puid'] as String?
    ..heroID = json['heroID'] as String?
    ..eggDate = zzz_str2Date(json['eggDate'] as String?)
    ..hatchDate = zzz_str2Date(json['hatchDate'] as String?)
    ..eggDuration = zzz_str2Dur(json['eggDuration'] as String?)
    ..eggImage = json['eggImage'] as String?
    ..eggImageURL = json['eggURL'] as String?
    ..name = json['heroName'] as String?
    ..bio = json['heroBio'] as String?
    ..heroImage = json['heroImage'] as String?
    ..imageURL = json['heroURL'] as String?
    ..ownDate = zzz_str2Date(json['ownDate'] as String?)
    ..evolution = json['evolution'] as String?
    ..power = json['power'] as String?
    ..energy = json['energy'] as String?
    ..bua = json['bua'] as String?
    ..bao = json['bao'] as String?
    ..keo = json['keo'] as String?
    ..status = json['heroStatus'] as String?;
}

Map<String, dynamic> _$KHeroToJson(KHero instance) => <String, dynamic>{
      'id': instance.id,
      'puid': instance.puid,
      'heroID': instance.heroID,
      'eggDate': zzz_date2Str(instance.eggDate),
      'hatchDate': zzz_date2Str(instance.hatchDate),
      'eggDuration': zzz_dur2Str(instance.eggDuration),
      'eggImage': instance.eggImage,
      'eggURL': instance.eggImageURL,
      'heroName': instance.name,
      'heroBio': instance.bio,
      'heroImage': instance.heroImage,
      'heroURL': instance.imageURL,
      'ownDate': zzz_date2Str(instance.ownDate),
      'evolution': instance.evolution,
      'power': instance.power,
      'energy': instance.energy,
      'bua': instance.bua,
      'bao': instance.bao,
      'keo': instance.keo,
      'heroStatus': instance.status,
    };
