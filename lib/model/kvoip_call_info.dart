import 'package:json_annotation/json_annotation.dart';

class KVoipCallInfo {
  @JsonKey(name: "uuid")
  String? uuid;

  @JsonKey(name: "callID")
  String? callID;

  // JSON
  KVoipCallInfo();
}
