import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_business_response.g.dart';

@JsonSerializable()
class GetBusinessResponse extends BaseResponse {
  @JsonKey(name: "business")
  Business? business;

  // JSON
  GetBusinessResponse();

  factory GetBusinessResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBusinessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetBusinessResponseToJson(this);
}
