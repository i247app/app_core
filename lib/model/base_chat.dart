import 'package:app_core/app_core.dart';
import 'package:app_core/helper/session_data.dart';
import 'package:app_core/model/app_core_chat_member.dart';
import 'package:app_core/model/app_core_chat_message.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class BaseChat {
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

  @JsonKey(name: "messages")
  List<AppCoreChatMessage>? messages;

  @JsonKey(name: "members")
  List<AppCoreChatMember>? members;

  @JsonKey(name: "activeDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? activeDate;

  /// Methods
  bool get isGroup => (this.members ?? []).length > 2;

  String get title {
    if ((this.members ?? []).length > 2)
      return (this.members ?? [])
          .where((m) => m.puid != SessionData.me!.puid)
          .map((m) => "${m.chatName}")
          .join(", ");
    if ((this.members ?? []).length == 2)
      return (this.members ?? [])
          .where((m) => m.puid != SessionData.me!.puid)
          .map((m) => "${m.displayName}")
          .join(", ");
    return '';
  }

  String? get firstInitial {
    if (members != null) {
      AppCoreChatMember? participant;
      if (!isGroup) {
        participant = (this.members ?? [])
            .firstWhereOrNull((r) => r.puid != SessionData.me?.puid);
      } else {
        participant = (this.members ?? []).first;
      }

      if (participant != null && (participant.firstName?.length ?? 0) > 1) {
        return participant.firstName?.substring(0, 1);
      } else {
        return participant?.firstName ?? "";
      }
    }

    return '';
  }
}
