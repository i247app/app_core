// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResumeSessionResponse _$ResumeSessionResponseFromJson(
        Map<String, dynamic> json) =>
    ResumeSessionResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..puid = json['puid'] as String?
      ..userSession = json['userSession'] == null
          ? null
          : KUserSession.fromJson(json['userSession'] as Map<String, dynamic>);

Map<String, dynamic> _$ResumeSessionResponseToJson(
    ResumeSessionResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('puid', instance.puid);
  writeNotNull('userSession', instance.userSession?.toJson());
  return val;
}
