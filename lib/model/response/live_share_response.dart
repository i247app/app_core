import 'package:app_core/app_core.dart';
import 'package:app_core/model/live_share.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_response.dart';

part 'live_share_response.g.dart';

@JsonSerializable()
class LiveShareResponse extends BaseResponse {
  static const String SHARES = "shares";
  static const String SS_ID = "ssID";

  @JsonKey(name: SS_ID)
  String? ssID;

  @JsonKey(name: "shares")
  List<LiveShare>? shares;

  // JSON
  LiveShareResponse();

  factory LiveShareResponse.fromJson(Map<String, dynamic> json) =>
      _$LiveShareResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LiveShareResponseToJson(this);
}
