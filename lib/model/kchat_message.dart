import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:app_core/model/kuser.dart';

part 'kchat_message.g.dart';

@JsonSerializable()
class KChatMessage {
  static const String CONTENT_TYPE_TEXT = "text";
  static const String CONTENT_TYPE_IMAGE = "image";
  static const String CONTENT_TYPE_VIDEO_CALL_EVENT = "video.call.event";
  static const String CONTENT_TYPE_CHAPTER = "chapter";

  static const String APP_CONTENT_CHAT = "chat";
  static const String APP_CONTENT_GIG = "gig";
  static const String APP_CONTENT_CUSUP = "cusup";

  @JsonKey(name: "messageID")
  String? messageID;

  @JsonKey(name: "chatID")
  String? chatID;

  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "messageDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? messageDate;

  @JsonKey(name: "messageType")
  String? messageType;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "messageStatus")
  String? messageStatus;

  @JsonKey(name: "imgData")
  String? imageData;

  @JsonKey(name: "refApp")
  String? refApp;

  @JsonKey(name: "refID")
  String? refID;

  @JsonKey(name: "user")
  KUser? user;

  // Helper
  @JsonKey(ignore: true)
  String? localID;

  @JsonKey(ignore: true)
  bool get isLocal => this.localID != null && this.messageID == null;

  @JsonKey(ignore: true)
  bool get isMe => puid == KSessionData.me?.puid;

  static String generateLocalID() => KUtil.buildRandomString(8);

  // JSON
  KChatMessage();

  factory KChatMessage.fromJson(Map<String, dynamic> json) =>
      _$KChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$KChatMessageToJson(this);
}
