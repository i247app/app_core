// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khero.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KHero _$KHeroFromJson(Map<String, dynamic> json) => KHero()
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

Map<String, dynamic> _$KHeroToJson(KHero instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('puid', instance.puid);
  writeNotNull('heroID', instance.heroID);
  writeNotNull('eggDate', zzz_date2Str(instance.eggDate));
  writeNotNull('hatchDate', zzz_date2Str(instance.hatchDate));
  writeNotNull('eggDuration', zzz_dur2Str(instance.eggDuration));
  writeNotNull('eggImage', instance.eggImage);
  writeNotNull('eggURL', instance.eggImageURL);
  writeNotNull('heroName', instance.name);
  writeNotNull('heroBio', instance.bio);
  writeNotNull('heroImage', instance.heroImage);
  writeNotNull('heroURL', instance.imageURL);
  writeNotNull('ownDate', zzz_date2Str(instance.ownDate));
  writeNotNull('evolution', instance.evolution);
  writeNotNull('power', instance.power);
  writeNotNull('energy', instance.energy);
  writeNotNull('bua', instance.bua);
  writeNotNull('bao', instance.bao);
  writeNotNull('keo', instance.keo);
  writeNotNull('heroStatus', instance.status);
  return val;
}
