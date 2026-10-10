// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kvoip_call_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KVoipCallInfo _$KVoipCallInfoFromJson(Map<String, dynamic> json) =>
    KVoipCallInfo()
      ..uuid = json['uuid'] as String?
      ..callID = json['callID'] as String?;

Map<String, dynamic> _$KVoipCallInfoToJson(KVoipCallInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uuid', instance.uuid);
  writeNotNull('callID', instance.callID);
  return val;
}
