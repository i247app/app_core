import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/helper/session_data.dart';
import 'package:app_core/helper/util.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:app_core/model/user.dart';

class AppCoreChatMessageType {
  static const String CONTENT_TYPE_TEXT = "text";
  static const String CONTENT_TYPE_IMAGE = "image";
  static const String CONTENT_TYPE_VIDEO_CALL_EVENT = "video.call.event";
}

class AppCoreChatMessageContent {
  static const String APP_CONTENT_CHAT = "chat";
  static const String APP_CONTENT_GIG = "gig";
  static const String APP_CONTENT_CUSUP = "cusup";
}

@JsonSerializable()
abstract class AppCoreChatMessage {
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

  // @JsonKey(name: "user")
  @JsonKey(ignore: true)
  AppCoreUser? _user;

  // Helper
  @JsonKey(ignore: true)
  String? localID;

  @JsonKey(ignore: true)
  bool get isLocal => this.localID != null && this.messageID == null;

  @JsonKey(ignore: true)
  bool get isMe => this.puid == AppCoreSessionData.me?.puid;

  static String generateLocalID() => AppCoreUtil.buildRandomString(8);
}
