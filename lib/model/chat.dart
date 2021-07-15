import 'package:app_core/helper/session_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/chat_member.dart';
import 'package:app_core/model/chat_message.dart';
import 'package:app_core/model/response/base_response.dart';

@JsonSerializable()
class AppCoreChat {
  static const String APP_CONTENT_CHAT = "chat";

  @JsonKey(name: "chatID")
  String? chatID;

  @JsonKey(name: "chatName")
  String? chatName;

  @JsonKey(name: "previewMessageID")
  String? previewMessageID;

  @JsonKey(name: "previewMessagePUID")
  String? previewMessagePUID;

  @JsonKey(name: "previewMessage")
  String? previewMessage;

  List<AppCoreChatMessage>? appCoreMessages;

  List<AppCoreChatMember>? appCoreMembers;

  @JsonKey(name: "activeDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? activeDate;

  @JsonKey(name: "refID")
  String? refID;

  @JsonKey(name: "refApp")
  String? refApp;

  /// Methods
  @JsonKey(ignore: true)
  bool get isGroup => (this.appCoreMembers ?? []).length > 2;

  @JsonKey(ignore: true)
  String get title {
    if ((this.appCoreMembers ?? []).length > 2)
      return this.chatName ?? (this.appCoreMembers ?? [])
          .where((m) => m.puid != AppCoreSessionData.me!.puid)
          .map((m) => "${m.chatName}")
          .join(", ");
    if ((this.appCoreMembers ?? []).length == 2)
      return (this.appCoreMembers ?? [])
          .where((m) => m.puid != AppCoreSessionData.me!.puid)
          .map((m) => "${m.displayName}")
          .join(", ");
    return '';
  }
}
