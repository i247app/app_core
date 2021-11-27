import 'package:json_annotation/json_annotation.dart';

import 'package:app_core/app_core.dart';

part 'bxfr_transfer_response.g.dart';

@JsonSerializable()
class BXFRTransferResponse extends BaseResponse {
  @JsonKey(name: "puid")
  String? puid;

  // JSON
  BXFRTransferResponse();

  factory BXFRTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$BXFRTransferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BXFRTransferResponseToJson(this);
}
