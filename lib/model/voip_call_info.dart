import 'package:json_annotation/json_annotation.dart';

part 'voip_call_info.g.dart';

@JsonSerializable()
class AppCoreVoipCallInfo {
  @JsonKey(name: "uuid")
  String? uuid;

  @JsonKey(name: "callID")
  String? callID;

  // JSON
  AppCoreVoipCallInfo();

  factory AppCoreVoipCallInfo.fromJson(Map<String, dynamic> json) =>
      _$AppCoreVoipCallInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AppCoreVoipCallInfoToJson(this);
}
