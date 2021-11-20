// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khost_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KHostInfo _$KHostInfoFromJson(Map<String, dynamic> json) => KHostInfo()
  ..hostname = json['hostname'] as String
  ..port = int.parse(json['port'] as String);

Map<String, dynamic> _$KHostInfoToJson(KHostInfo instance) {
  final val = <String, dynamic>{
    'hostname': instance.hostname,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('port', zzz_itoa(instance.port));
  return val;
}
