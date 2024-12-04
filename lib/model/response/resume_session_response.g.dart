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
        ResumeSessionResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.puid case final value?) 'puid': value,
      if (instance.userSession?.toJson() case final value?)
        'userSession': value,
    };
