import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AppCoreVoipCallInfo {
  @JsonKey(name: "uuid")
  String? uuid;

  @JsonKey(name: "callID")
  String? callID;

  // JSON
  AppCoreVoipCallInfo();
}
