// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareResponse _$ShareResponseFromJson(Map<String, dynamic> json) =>
    ShareResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..shares = (json['shares'] as List<dynamic>?)
          ?.map((e) => Share.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ShareResponseToJson(ShareResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.shares?.map((e) => e.toJson()).toList() case final value?)
        'shares': value,
    };
