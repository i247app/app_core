import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KChatListingController extends ValueNotifier<KChatListingData> {
  KChatListingController(KChatListingData value) : super(value);

  void loadChats() async {
    if (this.value.loadChats != null) {
      List<KChat>? chats = await this.value.loadChats!();

      this.value.chats = chats ?? [];
      notifyListeners();
    }
  }

  void removeChat(int chatIndex, KChat chat) async {
    if (chat.chatID == null || this.value.chats == null || this.value.removeChat == null)
      return;

    final response = await this.value.removeChat!(
      chat,
      KChat.APP_CONTENT_CHAT,
      null,
    );

    if (response) {
      this.value.chats!.removeAt(chatIndex);
      notifyListeners();
    }
  }
}
