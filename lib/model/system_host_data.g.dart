// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_host_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemHostData _$SystemHostDataFromJson(Map<String, dynamic> json) {
  return SystemHostData()
    ..webRtcHostInfo = json['webRTCHostInfo'] == null
        ? null
        : HostInfo.fromJson(json['webRTCHostInfo'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SystemHostDataToJson(SystemHostData instance) =>
    <String, dynamic>{
      'webRTCHostInfo': instance.webRtcHostInfo,
    };
