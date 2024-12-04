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
  ..heroStatus = json['heroStatus'] as String?;

Map<String, dynamic> _$KHeroToJson(KHero instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.puid case final value?) 'puid': value,
      if (instance.heroID case final value?) 'heroID': value,
      if (zzz_date2Str(instance.eggDate) case final value?) 'eggDate': value,
      if (zzz_date2Str(instance.hatchDate) case final value?)
        'hatchDate': value,
      if (zzz_dur2Str(instance.eggDuration) case final value?)
        'eggDuration': value,
      if (instance.eggImage case final value?) 'eggImage': value,
      if (instance.eggImageURL case final value?) 'eggURL': value,
      if (instance.name case final value?) 'heroName': value,
      if (instance.bio case final value?) 'heroBio': value,
      if (instance.heroImage case final value?) 'heroImage': value,
      if (instance.imageURL case final value?) 'heroURL': value,
      if (zzz_date2Str(instance.ownDate) case final value?) 'ownDate': value,
      if (instance.evolution case final value?) 'evolution': value,
      if (instance.power case final value?) 'power': value,
      if (instance.energy case final value?) 'energy': value,
      if (instance.bua case final value?) 'bua': value,
      if (instance.bao case final value?) 'bao': value,
      if (instance.keo case final value?) 'keo': value,
      if (instance.heroStatus case final value?) 'heroStatus': value,
    };
