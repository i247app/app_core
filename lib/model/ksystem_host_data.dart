import 'package:app_core/model/khost_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ksystem_host_data.g.dart';

@JsonSerializable()
class KSystemHostData {
  @JsonKey(name: "webRTCHostInfo")
  KHostInfo? webRtcHostInfo;

  // JSON
  KSystemHostData();

  factory KSystemHostData.fromJson(Map<String, dynamic> json) =>
      _$KSystemHostDataFromJson(json);

  Map<String, dynamic> toJson() => _$KSystemHostDataToJson(this);
}
