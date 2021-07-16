import 'package:app_core/model/kchat.dart';

class KChatListingData {
  List<KChat>? chats;
  Function()? loadChats;
  Function(KChat chat, String? refApp, String? refID)? removeChat;

  KChatListingData.fromRefData({
    this.chats,
    this.loadChats,
    this.removeChat,
  });

  KChatListingData({
    this.chats,
    this.loadChats,
    this.removeChat,
  });
}
