import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/notif_data.dart';
import 'package:app_core/model/push_data.dart';

@JsonSerializable()
class AppCoreFullNotification {
  static const String NOTIFICATION = "notification";
  static const String DATA = "data";

  @JsonKey(name: NOTIFICATION)
  AppCoreNotifData? notification;

  @JsonKey(name: DATA)
  AppCorePushData? data;

  @JsonKey(ignore: true)
  String? get app => this.data?.app;
}
