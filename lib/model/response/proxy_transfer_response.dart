import 'package:json_annotation/json_annotation.dart';

import 'package:app_core/app_core.dart';

part 'proxy_transfer_response.g.dart';

@JsonSerializable()
class ProxyTransferResponse extends BaseResponse {
  @JsonKey(name: "puid")
  String? puid;

  // JSON
  ProxyTransferResponse();

  factory ProxyTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$ProxyTransferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProxyTransferResponseToJson(this);
}
