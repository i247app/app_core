// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kvoip_call_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KVoipCallInfo _$KVoipCallInfoFromJson(Map<String, dynamic> json) =>
    KVoipCallInfo()
      ..uuid = json['uuid'] as String?
      ..callID = json['callID'] as String?;

Map<String, dynamic> _$KVoipCallInfoToJson(KVoipCallInfo instance) =>
    <String, dynamic>{
      if (instance.uuid case final value?) 'uuid': value,
      if (instance.callID case final value?) 'callID': value,
    };
