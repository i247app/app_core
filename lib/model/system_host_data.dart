import 'package:app_core/model/host_info.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AppCoreSystemHostData {
  static const String WEB_RTC_HOST = "webRTCHostInfo";

  @JsonKey(name: WEB_RTC_HOST)
  AppCoreHostInfo? webRtcHostInfo;

  // JSON
  AppCoreSystemHostData();
}
