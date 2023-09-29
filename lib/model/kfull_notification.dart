import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kfull_notification.g.dart';

@JsonSerializable()
class KFullNotification {
  static const String NOTIFICATION = "notification";
  static const String DATA = "data";

  @JsonKey(name: NOTIFICATION)
  KNotifData? notification;

  @JsonKey(name: DATA)
  KPushData? data;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get app => data?.app;

  // JSON
  KFullNotification();

  factory KFullNotification.fromJson(Map<String, dynamic> json) =>
      _$KFullNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$KFullNotificationToJson(this);
}
