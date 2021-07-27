import 'package:json_annotation/json_annotation.dart';

import 'base_response.dart';

part 'send_2fa_response.g.dart';

@JsonSerializable()
class KSend2faResponse extends BaseResponse {
  @JsonKey(name: "kpin")
  String? kpin;
  
  // JSON
  KSend2faResponse();

  factory KSend2faResponse.fromJson(Map<String, dynamic> json) =>
      _$KSend2faResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KSend2faResponseToJson(this);
}
