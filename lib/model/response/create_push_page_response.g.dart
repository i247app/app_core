// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_push_page_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePushPageResponse _$CreatePushPageResponseFromJson(
        Map<String, dynamic> json) =>
    CreatePushPageResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..ssID = json['ssID'] as String?;

Map<String, dynamic> _$CreatePushPageResponseToJson(
    CreatePushPageResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('ssID', instance.ssID);
  return val;
}
