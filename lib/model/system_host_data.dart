import 'package:app_core/model/host_info.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AppCoreSystemHostData {
  @JsonKey(ignore: true)
  AppCoreHostInfo? appCoreWebRtcHostInfo;
}
