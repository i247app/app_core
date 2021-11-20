// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_2fa_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KSend2faResponse _$KSend2faResponseFromJson(Map<String, dynamic> json) =>
    KSend2faResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..kpin = json['kpin'] as String?;

Map<String, dynamic> _$KSend2faResponseToJson(KSend2faResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('kpin', instance.kpin);
  return val;
}
