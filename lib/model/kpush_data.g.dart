// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kpush_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KPushData _$KPushDataFromJson(Map<String, dynamic> json) {
  return KPushData()
    ..pushType = json['pushType'] as String?
    ..app = json['app'] as String?
    ..id = json['id'] as String?
    ..refApp = json['refApp'] as String?
    ..refID = json['refID'] as String?
    ..otherId = json['other_id'] as String?
    ..callerName = json['callName'] as String?
    ..uuid = json['uuid'] as String?
    ..confettiCount = zzz_atoi(json['confettiCount'] as String?)
    ..confettiType = json['confettiType'] as String?
    ..message = json['message'] as String?;
}

Map<String, dynamic> _$KPushDataToJson(KPushData instance) => <String, dynamic>{
      'pushType': instance.pushType,
      'app': instance.app,
      'id': instance.id,
      'refApp': instance.refApp,
      'refID': instance.refID,
      'other_id': instance.otherId,
      'callName': instance.callerName,
      'uuid': instance.uuid,
      'confettiCount': zzz_itoa(instance.confettiCount),
      'confettiType': instance.confettiType,
      'message': instance.message,
    };
