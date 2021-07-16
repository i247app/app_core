import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/model/kchat_message.dart';

class KChatroomData {
  String? chatID;
  String? chatTitle;
  String? refApp;
  String? refID;
  List<KChatMember>? members;
  List<KChatMessage>? messages;
  Function({String? chatID, String? refApp, String? refID})? getChat;
  Function({required KChatMessage message, List<String>? refPUIDs})?
      sendMessage;

  // true until chats have loaded for the first time
  bool get isInitializing => this.messages == null;

  KChatroomData.fromChatID(String chatID) : this.chatID = chatID;

  KChatroomData.fromRefData({
    required this.refApp,
    required this.refID,
    this.chatID,
    this.members,
    this.messages,
    this.getChat,
    this.sendMessage,
  });

  KChatroomData({
    this.chatID,
    this.chatTitle,
    this.refApp,
    this.refID,
    this.members,
    this.messages,
    this.getChat,
    this.sendMessage,
  });
}
