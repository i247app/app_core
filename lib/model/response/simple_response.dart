import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'simple_response.g.dart';

@JsonSerializable()
class SimpleResponse extends BaseResponse {
  // JSON
  SimpleResponse();

  factory SimpleResponse.fromJson(Map<String, dynamic> json) =>
      _$SimpleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleResponseToJson(this);
}
