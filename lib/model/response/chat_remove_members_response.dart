import 'package:json_annotation/json_annotation.dart';

import '../kchat_member.dart';
import 'base_response.dart';

part 'chat_remove_members_response.g.dart';

@JsonSerializable()
class KChatRemoveMembersResponse extends BaseResponse {
  @JsonKey(name: "members")
  List<KChatMember>? members;

  // JSON
  KChatRemoveMembersResponse();

  factory KChatRemoveMembersResponse.fromJson(Map<String, dynamic> json) =>
      _$KChatRemoveMembersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KChatRemoveMembersResponseToJson(this);
}
