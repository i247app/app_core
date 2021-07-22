import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';
part 'search_users_response.g.dart';

@JsonSerializable()
class SearchUsersResponse extends BaseResponse {
  @JsonKey(name: "users")
  List<KUser>? users;

  // JSON
  SearchUsersResponse();

  factory SearchUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchUsersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchUsersResponseToJson(this);
}
