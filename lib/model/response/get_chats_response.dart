import 'package:json_annotation/json_annotation.dart';

import '../kchat.dart';
import 'base_response.dart';

part 'get_chats_response.g.dart';

@JsonSerializable()
class KGetChatsResponse extends BaseResponse {
  @JsonKey(name: "chats")
  List<KChat>? chats;

  // JSON
  KGetChatsResponse();

  factory KGetChatsResponse.fromJson(Map<String, dynamic> json) =>
      _$KGetChatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KGetChatsResponseToJson(this);
}
