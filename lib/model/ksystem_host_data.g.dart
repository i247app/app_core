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

Map<String, dynamic> _$KSystemHostDataToJson(KSystemHostData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('webRTCHostInfo', instance.webRtcHostInfo?.toJson());
  return val;
}
