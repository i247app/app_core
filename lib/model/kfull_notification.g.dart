// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kfull_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KFullNotification _$KFullNotificationFromJson(Map<String, dynamic> json) =>
    KFullNotification()
      ..notification = json['notification'] == null
          ? null
          : KNotifData.fromJson(json['notification'] as Map<String, dynamic>)
      ..data = json['data'] == null
          ? null
          : KPushData.fromJson(json['data'] as Map<String, dynamic>);

Map<String, dynamic> _$KFullNotificationToJson(KFullNotification instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('notification', instance.notification?.toJson());
  writeNotNull('data', instance.data?.toJson());
  return val;
}
