// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kfull_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KFullNotification _$KFullNotificationFromJson(Map<String, dynamic> json) {
  return KFullNotification()
    ..notification = json['notification'] == null
        ? null
        : KNotifData.fromJson(json['notification'] as Map<String, dynamic>)
    ..data = json['data'] == null
        ? null
        : KPushData.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$KFullNotificationToJson(KFullNotification instance) =>
    <String, dynamic>{
      'notification': instance.notification,
      'data': instance.data,
    };
