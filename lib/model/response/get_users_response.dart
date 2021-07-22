import 'package:app_core/model/kuser.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_response.dart';

part 'get_users_response.g.dart';

@JsonSerializable()
class GetUsersResponse extends BaseResponse {
  @JsonKey(name: "users")
  List<KUser>? users;

  /// Methods
  @JsonKey(ignore: true)
  KUser? get user => (this.users ?? []).isEmpty ? null : this.users!.first;

  // JSON
  GetUsersResponse();

  factory GetUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUsersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetUsersResponseToJson(this);
}
