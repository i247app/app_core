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
  ..callerId = json['caller_id'] as int?
  ..callType = json['call_type'] as int?
  ..sessionId = json['session_id'] as String?
  ..callerName = json['caller_name'] as String?
  ..callOpponents = json['call_opponents'] as String?
  ..userInfo = json['user_info'] as String?
  ..confettiCount = zzz_atoi(json['confettiCount'] as String?)
  ..message = json['message'] as String?;

Map<String, dynamic> _$KPushDataToJson(KPushData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('pushType', instance.pushType);
  writeNotNull('app', instance.app);
  writeNotNull('id', instance.id);
  writeNotNull('index', instance.index);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('refID', instance.refID);
  writeNotNull('rem', instance.rem);
  writeNotNull('other_id', instance.otherId);
  writeNotNull('uuid', instance.uuid);
  writeNotNull('caller_id', instance.callerId);
  writeNotNull('call_type', instance.callType);
  writeNotNull('session_id', instance.sessionId);
  writeNotNull('caller_name', instance.callerName);
  writeNotNull('call_opponents', instance.callOpponents);
  writeNotNull('user_info', instance.userInfo);
  writeNotNull('confettiCount', zzz_itoa(instance.confettiCount));
  writeNotNull('message', instance.message);
  return val;
}
