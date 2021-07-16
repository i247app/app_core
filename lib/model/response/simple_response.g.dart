// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleResponse _$SimpleResponseFromJson(Map<String, dynamic> json) {
  return SimpleResponse()
    ..kstatus = zzz_parseInt(json['kstatus'] as String?)
    ..kmessage = json['kmessage'] as String?
    ..ktoken = json['ktoken'] as String?;
}

Map<String, dynamic> _$SimpleResponseToJson(SimpleResponse instance) =>
    <String, dynamic>{
      'kstatus': zzz_itoa(instance.kstatus),
      'kmessage': instance.kmessage,
      'ktoken': instance.ktoken,
    };
