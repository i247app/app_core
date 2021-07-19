import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_add_members_response.g.dart';

@JsonSerializable()
class ChatAddMembersResponse extends BaseResponse {
  @JsonKey(name: "members")
  List<KChatMember>? members;

  // JSON
  ChatAddMembersResponse();

  factory ChatAddMembersResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatAddMembersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatAddMembersResponseToJson(this);
}
