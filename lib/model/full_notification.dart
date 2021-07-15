import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/notif_data.dart';
import 'package:app_core/model/push_data.dart';

class KFullNotification {
  @JsonKey(ignore: true)
  KNotifData? appCoreNotification;

  @JsonKey(ignore: true)
  KPushData? appCoreData;

  @JsonKey(ignore: true)
  String? get app => this.appCoreData?.app;
}
