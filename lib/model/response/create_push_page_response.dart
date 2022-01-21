import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_push_page_response.g.dart';

@JsonSerializable()
class CreatePushPageResponse extends BaseResponse {
  @JsonKey(name: "ssID")
  String? ssID;

  // JSON
  CreatePushPageResponse();

  factory CreatePushPageResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePushPageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePushPageResponseToJson(this);
}
