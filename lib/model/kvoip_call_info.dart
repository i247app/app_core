import 'package:json_annotation/json_annotation.dart';

part 'kvoip_call_info.g.dart';

@JsonSerializable()
class KVoipCallInfo {
  @JsonKey(name: "uuid")
  String? uuid;

  @JsonKey(name: "callID")
  String? callID;

  // JSON
  KVoipCallInfo();

  factory KVoipCallInfo.fromJson(Map<String, dynamic> json) =>
      _$KVoipCallInfoFromJson(json);

  Map<String, dynamic> toJson() => _$KVoipCallInfoToJson(this);
}
