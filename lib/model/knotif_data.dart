import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:json_annotation/json_annotation.dart';

class KNotifData {
  static const String TITLE = "title";
  static const String BODY = "body";

  @JsonKey(name: TITLE)
  String? title;

  @JsonKey(name: BODY)
  String? body;

  /// From
  factory KNotifData.fromFCMRemoteNotification(
          RemoteNotification? notification) =>
      KNotifData()
        ..title = notification?.title ?? ""
        ..body = notification?.body ?? "";

  KNotifData();
}
