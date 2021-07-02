// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HostInfo _$HostInfoFromJson(Map<String, dynamic> json) {
  return HostInfo()
    ..hostname = json['hostname'] as String
    ..port = int.parse(json['port'] as String);
}

Map<String, dynamic> _$HostInfoToJson(HostInfo instance) => <String, dynamic>{
      'hostname': instance.hostname,
      'port': zzz_itoa(instance.port),
    };
