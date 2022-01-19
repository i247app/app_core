import 'package:app_core/app_core.dart';
import 'package:app_core/model/textbook.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_textbooks_response.g.dart';

@JsonSerializable()
class ListTextbooksResponse extends BaseResponse {
  @JsonKey(name: "textbooks")
  List<Textbook>? textbooks;

  // JSON
  ListTextbooksResponse();

  factory ListTextbooksResponse.fromJson(Map<String, dynamic> json) =>
      _$ListTextbooksResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListTextbooksResponseToJson(this);
}
