import 'package:app_core/helper/ksession_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/model/kchat_message.dart';
import 'package:app_core/model/response/base_response.dart';

part 'kchat.g.dart';

@JsonSerializable()
class KChat {
  static const String APP_CONTENT_CHAT = "chat";
  static const String APP_CONTENT_SUPPORT = "cusup";

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

  @JsonKey(name: "chatMessages")
  List<KChatMessage>? kMessages;

  @JsonKey(name: "members")
  List<KChatMember>? kMembers;

  @JsonKey(name: "activeDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? activeDate;

  @JsonKey(name: "refID")
  String? refID;

  @JsonKey(name: "refApp")
  String? refApp;

  @JsonKey(name: "domain")
  String? domain;

  /// Methods
  @JsonKey(ignore: true)
  bool get isGroup => (this.kMembers ?? []).length > 2;

  @JsonKey(ignore: true)
  String get title {
    if ((this.kMembers ?? []).length > 2)
      return this.chatName ??
          (this.kMembers ?? [])
              .where((m) => m.puid != KSessionData.me!.puid)
              .map((m) => "${m.chatName}")
              .join(", ");
    if ((this.kMembers ?? []).length == 2)
      return (this.kMembers ?? [])
          .where((m) => m.puid != KSessionData.me!.puid)
          .map((m) => "${m.displayName}")
          .join(", ");
    return '';
  }

  // JSON
  KChat();

  factory KChat.fromJson(Map<String, dynamic> json) => _$KChatFromJson(json);

  Map<String, dynamic> toJson() => _$KChatToJson(this);
}
