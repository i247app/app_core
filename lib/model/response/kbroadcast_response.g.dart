// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kbroadcast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KBroadcastResponse _$KBroadcastResponseFromJson(Map<String, dynamic> json) =>
    KBroadcastResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..broadcasts = (json['kbroadcasts'] as List<dynamic>?)
          ?.map((e) => KBroadcast.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KBroadcastResponseToJson(KBroadcastResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.broadcasts?.map((e) => e.toJson()).toList()
          case final value?)
        'kbroadcasts': value,
    };
