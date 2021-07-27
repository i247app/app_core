// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_2fa_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KSend2faResponse _$KSend2faResponseFromJson(Map<String, dynamic> json) {
  return KSend2faResponse()
    ..kstatus = zzz_parseInt(json['kstatus'] as String?)
    ..kmessage = json['kmessage'] as String?
    ..ktoken = json['ktoken'] as String?
    ..kpin = json['kpin'] as String?;
}

Map<String, dynamic> _$KSend2faResponseToJson(KSend2faResponse instance) =>
    <String, dynamic>{
      'kstatus': zzz_itoa(instance.kstatus),
      'kmessage': instance.kmessage,
      'ktoken': instance.ktoken,
      'kpin': instance.kpin,
    };
