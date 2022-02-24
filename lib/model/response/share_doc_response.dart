import 'package:app_core/app_core.dart';
import 'package:app_core/model/share.dart';
import 'package:json_annotation/json_annotation.dart';

part 'share_doc_response.g.dart';

@JsonSerializable()
class ShareDocResponse extends BaseResponse {
  static const String SHARES = "shares";
  static const String SSID = "ssID";

  @JsonKey(name: SSID)
  String? ssID;

  @JsonKey(name: SHARES)
  List<Share>? shares;

  // JSON
  ShareDocResponse();

  factory ShareDocResponse.fromJson(Map<String, dynamic> json) =>
      _$ShareDocResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShareDocResponseToJson(this);
}
