import 'package:app_core/model/khost_info.dart';
import 'package:json_annotation/json_annotation.dart';

class KSystemHostData {
  @JsonKey(ignore: true)
  KHostInfo? appCoreWebRtcHostInfo;
}
