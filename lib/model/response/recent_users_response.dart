import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';
part 'recent_users_response.g.dart';

@JsonSerializable()
class RecentUsersResponse extends BaseResponse {
  @JsonKey(name: "recentUsers")
  List<KUser>? users;

  // JSON
  RecentUsersResponse();

  factory RecentUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$RecentUsersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecentUsersResponseToJson(this);
}
