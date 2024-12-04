// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ksystem_host_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KSystemHostData _$KSystemHostDataFromJson(Map<String, dynamic> json) =>
    KSystemHostData()
      ..webRtcHostInfo = json['webRTCHostInfo'] == null
          ? null
          : KHostInfo.fromJson(json['webRTCHostInfo'] as Map<String, dynamic>);

Map<String, dynamic> _$KSystemHostDataToJson(KSystemHostData instance) =>
    <String, dynamic>{
      if (instance.webRtcHostInfo?.toJson() case final value?)
        'webRTCHostInfo': value,
    };
