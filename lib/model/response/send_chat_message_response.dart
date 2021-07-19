import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_chat_message_response.g.dart';

@JsonSerializable()
class SendChatMessageResponse extends BaseResponse {
  @JsonKey(name: "chatMessage")
  KChatMessage? chatMessage;

  // JSON
  SendChatMessageResponse();

  factory SendChatMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendChatMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendChatMessageResponseToJson(this);
}
