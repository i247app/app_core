// import 'package:app_core/model/chat_member.dart';
// import 'package:app_core/model/chat_message.dart';
// import 'package:app_core/model/response/get_chat_response.dart';
//
// class ChatroomData {
//   String? chatID;
//   String? chatTitle;
//   String? refApp;
//   String? refID;
//   List<ChatMember>? members;
//   List<ChatMessage>? messages;
//   GetChatResponse? response;
//
//   // true until chats have loaded for the first time
//   bool get isInitializing => this.response == null;
//
//   ChatroomData.fromChatID(String chatID) : this.chatID = chatID;
//
//   ChatroomData.fromRefData({
//     required this.refApp,
//     required this.refID,
//     this.chatID,
//     this.members,
//     this.messages,
//   });
//
//   ChatroomData({
//     this.chatID,
//     this.chatTitle,
//     this.refApp,
//     this.refID,
//     this.members,
//     this.messages,
//   });
// }
