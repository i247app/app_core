// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voip_call_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCoreVoipCallInfo _$AppCoreVoipCallInfoFromJson(Map<String, dynamic> json) {
  return AppCoreVoipCallInfo()
    ..uuid = json['uuid'] as String?
    ..callID = json['callID'] as String?;
}

Map<String, dynamic> _$AppCoreVoipCallInfoToJson(
        AppCoreVoipCallInfo instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'callID': instance.callID,
    };
