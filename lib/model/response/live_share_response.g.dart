// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_share_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveShareResponse _$LiveShareResponseFromJson(Map<String, dynamic> json) =>
    LiveShareResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..ssID = json['ssID'] as String?
      ..shares = (json['shares'] as List<dynamic>?)
          ?.map((e) => LiveShare.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$LiveShareResponseToJson(LiveShareResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.ssID case final value?) 'ssID': value,
      if (instance.shares?.map((e) => e.toJson()).toList() case final value?)
        'shares': value,
    };
