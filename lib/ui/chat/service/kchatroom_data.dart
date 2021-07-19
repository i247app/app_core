import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/model/kchat_message.dart';
import 'package:app_core/model/response/get_chat_response.dart';

class KChatroomData {
  String? chatID;
  String? chatTitle;
  String? refApp;
  String? refID;
  List<KChatMember>? members;
  List<KChatMessage>? messages;
  GetChatResponse? response;

  // true until chats have loaded for the first time
  bool get isInitializing => this.response == null;

  KChatroomData.fromChatID(String chatID) : this.chatID = chatID;

  KChatroomData.fromRefData({
    required this.refApp,
    required this.refID,
    this.chatID,
    this.members,
    this.messages,
  });

  KChatroomData({
    this.chatID,
    this.chatTitle,
    this.refApp,
    this.refID,
    this.members,
    this.messages,
  });
}
