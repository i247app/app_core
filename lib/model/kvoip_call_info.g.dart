// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kvoip_call_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KVoipCallInfo _$KVoipCallInfoFromJson(Map<String, dynamic> json) {
  return KVoipCallInfo()
    ..uuid = json['uuid'] as String?
    ..callID = json['callID'] as String?;
}

Map<String, dynamic> _$KVoipCallInfoToJson(KVoipCallInfo instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'callID': instance.callID,
    };
