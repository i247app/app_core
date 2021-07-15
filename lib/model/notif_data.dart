import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AppCoreNotifData {
  static const String TITLE = "title";
  static const String BODY = "body";

  @JsonKey(name: TITLE)
  String? title;

  @JsonKey(name: BODY)
  String? body;

  /// From
  factory AppCoreNotifData.fromFCMRemoteNotification(
          RemoteNotification? notification) =>
      AppCoreNotifData()
        ..title = notification?.title ?? ""
        ..body = notification?.body ?? "";

  AppCoreNotifData();
}
