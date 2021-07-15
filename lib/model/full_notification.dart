import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/notif_data.dart';
import 'package:app_core/model/push_data.dart';

@JsonSerializable()
class AppCoreFullNotification {
  @JsonKey(ignore: true)
  AppCoreNotifData? appCoreNotification;

  @JsonKey(ignore: true)
  AppCorePushData? appCoreData;

  @JsonKey(ignore: true)
  String? get app => this.appCoreData?.app;
}
