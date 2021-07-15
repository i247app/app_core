import 'package:app_core/model/chat_member.dart';
import 'package:app_core/model/chat_message.dart';

class AppCoreChatroomData {
  String? chatID;
  String? chatTitle;
  String? refApp;
  String? refID;
  List<AppCoreChatMember>? members;
  List<AppCoreChatMessage>? messages;
  Function({ String? chatID, String? refApp, String? refID })? getChat;
  Function({ AppCoreChatMessage? message, List<String>? refPUIDs })? sendMessage;

  // true until chats have loaded for the first time
  bool get isInitializing => this.messages == null;

  AppCoreChatroomData.fromChatID(String chatID) : this.chatID = chatID;

  AppCoreChatroomData.fromRefData({
    required this.refApp,
    required this.refID,
    this.chatID,
    this.members,
    this.messages,
    this.getChat,
    this.sendMessage,
  });

  AppCoreChatroomData({
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
