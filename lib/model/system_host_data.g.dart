// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_host_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCoreSystemHostData _$AppCoreSystemHostDataFromJson(
    Map<String, dynamic> json) {
  return AppCoreSystemHostData()
    ..webRtcHostInfo = json['webRTCHostInfo'] == null
        ? null
        : AppCoreHostInfo.fromJson(
            json['webRTCHostInfo'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AppCoreSystemHostDataToJson(
        AppCoreSystemHostData instance) =>
    <String, dynamic>{
      'webRTCHostInfo': instance.webRtcHostInfo,
    };
