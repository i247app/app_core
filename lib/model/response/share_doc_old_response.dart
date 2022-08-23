import 'package:app_core/app_core.dart';
import 'package:app_core/model/share.dart';
import 'package:json_annotation/json_annotation.dart';

part 'share_doc_old_response.g.dart';

@JsonSerializable()
class ShareDocOldResponse extends BaseResponse {
  static const String SHARES = "shares";
  static const String SSID = "ssID";

  @JsonKey(name: SSID)
  String? ssID;

  @JsonKey(name: SHARES)
  List<Share>? shares;

  // JSON
  ShareDocOldResponse();

  factory ShareDocOldResponse.fromJson(Map<String, dynamic> json) =>
      _$ShareDocOldResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShareDocOldResponseToJson(this);
}
