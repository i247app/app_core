// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khost_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KHostInfo _$KHostInfoFromJson(Map<String, dynamic> json) {
  return KHostInfo()
    ..hostname = json['hostname'] as String
    ..port = int.parse(json['port'] as String);
}

Map<String, dynamic> _$KHostInfoToJson(KHostInfo instance) => <String, dynamic>{
      'hostname': instance.hostname,
      'port': zzz_itoa(instance.port),
    };
