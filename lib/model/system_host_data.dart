import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/host_info.dart';

part 'system_host_data.g.dart';

@JsonSerializable()
class SystemHostData {
  static const String WEB_RTC_HOST = "webRTCHostInfo";

  @JsonKey(name: WEB_RTC_HOST)
  HostInfo? webRtcHostInfo;

  // JSON
  SystemHostData();

  factory SystemHostData.fromJson(Map<String, dynamic> json) =>
      _$SystemHostDataFromJson(json);

  Map<String, dynamic> toJson() => _$SystemHostDataToJson(this);
}
