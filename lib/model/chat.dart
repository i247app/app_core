import 'package:app_core/helper/session_data.dart';
import 'package:app_core/model/chat_member.dart';
import 'package:app_core/model/chat_message.dart';
import 'package:collection/collection.dart';

class AppCoreChat {
  String? chatID;

  String? chatName;

  String? previewMessageID;

  String? previewMessagePUID;

  String? previewMessage;

  List<AppCoreChatMessage>? messages;

  List<AppCoreChatMember>? members;

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

  AppCoreChat();
}
