import 'package:app_core/app_core.dart';
import 'package:app_core/model/share.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_response.dart';

part 'share_response.g.dart';

@JsonSerializable()
class ShareResponse extends BaseResponse {
  static const String SHARES = "shares";
  static const String SS_ID = "ssID";

  @JsonKey(name: SS_ID)
  String? ssID;

  @JsonKey(name: "shares")
  List<Share>? shares;

  // JSON
  ShareResponse();

  factory ShareResponse.fromJson(Map<String, dynamic> json) =>
      _$ShareResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShareResponseToJson(this);
}
