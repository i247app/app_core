// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_doc_old_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareDocOldResponse _$ShareDocOldResponseFromJson(Map<String, dynamic> json) =>
    ShareDocOldResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..ssID = json['ssID'] as String?
      ..shares = (json['shares'] as List<dynamic>?)
          ?.map((e) => LiveShare.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ShareDocOldResponseToJson(
        ShareDocOldResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.ssID case final value?) 'ssID': value,
      if (instance.shares?.map((e) => e.toJson()).toList() case final value?)
        'shares': value,
    };
