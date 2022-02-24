import 'package:json_annotation/json_annotation.dart';
import '../share.dart';

part 'share_response.g.dart';

@JsonSerializable()
class ShareResponse {
  @JsonKey(name: "shares")
  List<Share>? shares;

  // JSON
  ShareResponse();

  factory ShareResponse.fromJson(Map<String, dynamic> json) =>
      _$ShareResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShareResponseToJson(this);
}
