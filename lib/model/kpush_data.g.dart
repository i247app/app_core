// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kpush_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KPushData _$KPushDataFromJson(Map<String, dynamic> json) => KPushData()
  ..pushType = json['pushType'] as String?
  ..app = json['app'] as String?
  ..id = json['id'] as String?
  ..index = json['index'] as String?
  ..refApp = json['refApp'] as String?
  ..refID = json['refID'] as String?
  ..rem = json['rem'] as String?
  ..otherId = json['other_id'] as String?
  ..uuid = json['uuid'] as String?
  ..callerId = (json['caller_id'] as num?)?.toInt()
  ..callType = (json['call_type'] as num?)?.toInt()
  ..sessionId = json['session_id'] as String?
  ..conferenceSlug = json['conference_slug'] as String?
  ..callerName = json['caller_name'] as String?
  ..callOpponents = json['call_opponents'] as String?
  ..userInfo = json['user_info'] as String?
  ..confettiCount = zzz_atoi(json['confettiCount'] as String?)
  ..message = json['message'] as String?;

Map<String, dynamic> _$KPushDataToJson(KPushData instance) => <String, dynamic>{
      if (instance.pushType case final value?) 'pushType': value,
      if (instance.app case final value?) 'app': value,
      if (instance.id case final value?) 'id': value,
      if (instance.index case final value?) 'index': value,
      if (instance.refApp case final value?) 'refApp': value,
      if (instance.refID case final value?) 'refID': value,
      if (instance.rem case final value?) 'rem': value,
      if (instance.otherId case final value?) 'other_id': value,
      if (instance.uuid case final value?) 'uuid': value,
      if (instance.callerId case final value?) 'caller_id': value,
      if (instance.callType case final value?) 'call_type': value,
      if (instance.sessionId case final value?) 'session_id': value,
      if (instance.conferenceSlug case final value?) 'conference_slug': value,
      if (instance.callerName case final value?) 'caller_name': value,
      if (instance.callOpponents case final value?) 'call_opponents': value,
      if (instance.userInfo case final value?) 'user_info': value,
      if (zzz_itoa(instance.confettiCount) case final value?)
        'confettiCount': value,
      if (instance.message case final value?) 'message': value,
    };
