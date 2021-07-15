import 'package:app_core/model/host_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'system_host_data.g.dart';

@JsonSerializable()
class AppCoreSystemHostData {
  static const String WEB_RTC_HOST = "webRTCHostInfo";

  @JsonKey(name: WEB_RTC_HOST)
  AppCoreHostInfo? webRtcHostInfo;

  // JSON
  AppCoreSystemHostData();

  factory AppCoreSystemHostData.fromJson(Map<String, dynamic> json) =>
      _$AppCoreSystemHostDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppCoreSystemHostDataToJson(this);
}
