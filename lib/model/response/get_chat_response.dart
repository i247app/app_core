import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_chat_response.g.dart';

@JsonSerializable()
class GetChatResponse extends BaseResponse {
@JsonKey(name: "chat")
KChat? chat;

// JSON
GetChatResponse();

factory GetChatResponse.fromJson(Map<String, dynamic> json) =>
_$GetChatResponseFromJson(json);

Map<String, dynamic> toJson() => _$GetChatResponseToJson(this);
}