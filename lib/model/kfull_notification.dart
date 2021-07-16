import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/knotif_data.dart';
import 'package:app_core/model/kpush_data.dart';

class KFullNotification {
  @JsonKey(ignore: true)
  KNotifData? appCoreNotification;

  @JsonKey(ignore: true)
  KPushData? appCoreData;

  @JsonKey(ignore: true)
  String? get app => this.appCoreData?.app;
}
