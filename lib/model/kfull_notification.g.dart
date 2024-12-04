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

Map<String, dynamic> _$KFullNotificationToJson(KFullNotification instance) =>
    <String, dynamic>{
      if (instance.notification?.toJson() case final value?)
        'notification': value,
      if (instance.data?.toJson() case final value?) 'data': value,
    };
