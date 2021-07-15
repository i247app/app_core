// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCoreHostInfo _$AppCoreHostInfoFromJson(Map<String, dynamic> json) {
  return AppCoreHostInfo()
    ..hostname = json['hostname'] as String
    ..port = int.parse(json['port'] as String);
}

Map<String, dynamic> _$AppCoreHostInfoToJson(AppCoreHostInfo instance) =>
    <String, dynamic>{
      'hostname': instance.hostname,
      'port': zzz_itoa(instance.port),
    };
