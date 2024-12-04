// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_action_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoActionResponse _$VideoActionResponseFromJson(Map<String, dynamic> json) =>
    VideoActionResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..foos = (json['foos'] as List<dynamic>?)
          ?.map((e) => KFoo.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$VideoActionResponseToJson(
        VideoActionResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.foos?.map((e) => e.toJson()).toList() case final value?)
        'foos': value,
    };
