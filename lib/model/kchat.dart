import 'package:app_core/helper/ksession_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/model/kchat_message.dart';
import 'package:app_core/model/response/kbase_response.dart';

abstract class KChat {
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

  @JsonKey(ignore: true)
  List<KChatMessage>? appCoreMessages;

  @JsonKey(ignore: true)
  List<KChatMember>? appCoreMembers;

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
      return this.chatName ??
          (this.appCoreMembers ?? [])
              .where((m) => m.puid != KSessionData.me!.puid)
              .map((m) => "${m.chatName}")
              .join(", ");
    if ((this.appCoreMembers ?? []).length == 2)
      return (this.appCoreMembers ?? [])
          .where((m) => m.puid != KSessionData.me!.puid)
          .map((m) => "${m.displayName}")
          .join(", ");
    return '';
  }
}
