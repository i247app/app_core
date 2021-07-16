import 'package:app_core/app_core.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/kphoto_helper.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/kchat_message.dart';
import 'package:app_core/ui/chat/service/kchatroom_data.dart';

class KChatroomController extends ValueNotifier<KChatroomData> {
  static const int MAX_MESSAGE_COUNT = 100;

  KChatMessage get messageTemplate => KChatMessage()
    ..chatID = this.value.chatID
    ..localID = KChatMessage.generateLocalID()
    ..puid = KSessionData.me?.puid
    ..refApp = this.value.refApp
    ..refID = this.value.refID
    ..messageDate = DateTime.now();

  KChatroomController(KChatroomData value) : super(value);

  Future<String?> sendVideoCallEvent() async => sendMessage(
        messageType: KChatMessage.CONTENT_TYPE_VIDEO_CALL_EVENT,
        text: "Video call ${KUtil.prettyDate(DateTime.now())}",
      );

  Future<String?> sendText(String message) async {
    final String sanitized = message.trim();
    if (sanitized.isEmpty) return null;

    return sendMessage(
      messageType: KChatMessage.CONTENT_TYPE_TEXT,
      text: sanitized,
    );
  }

  Future<String?> sendImage(KPhotoResult result) async {
    if (result.status != KPhotoStatus.ok) return null;

    return sendMessage(
      messageType: KChatMessage.CONTENT_TYPE_IMAGE,
      imageData: result.photoFile == null
          ? null
          : KUtil.fileToBase64(result.photoFile!),
    );
  }

  Future<String?> sendMessage({
    required String messageType,
    String? imageData,
    String? text,
  }) async =>
      _sendChatMessage(this.messageTemplate
        ..messageType = messageType
        ..imageData = imageData
        ..message = text);

  void loadChat() async {
    if (this.value.getChat != null) {
      final chat = await this.value.getChat!(
        chatID: this.value.chatID,
        refApp: this.value.refApp,
        refID: this.value.refID,
      );

      this.value.members = chat?.members;
      this.value.messages ??= [];
      notifyListeners();

      if (chat == null || chat?.messages == null) return;

      // Merge algorithm
      final List<String> msgIdsForDeletion = [];
      for (var it1 = this.value.messages!.iterator; it1.moveNext();) {
        for (var it2 = chat!.messages!.iterator; it2.moveNext();) {
          // If chat array contains a chat with same messageID as incoming
          // chat from server, delete the local version
          if (it1.current.messageID == it2.current.messageID
              // && it1.current.localID != null
              ) {
            msgIdsForDeletion.add(it1.current.messageID ?? "");
          }
        }
      }
      this
          .value
          .messages!
          .removeWhere((e) => msgIdsForDeletion.contains(e.messageID));

      this.value.messages!.addAll(chat!.messages!);

      // Truncate chats to MAX MESSAGE LENGTH
      if (this.value.messages!.length > MAX_MESSAGE_COUNT)
        this.value.messages = this
            .value
            .messages!
            .sublist(this.value.messages!.length - MAX_MESSAGE_COUNT);

      // Sort by create date
      this.value.messages!.sort((a, b) {
        final lhs = b;
        final rhs = a;
        return lhs.messageDate!.compareTo(rhs.messageDate!);
      });

      notifyListeners();
    }
  }

  ///
  /// PRIVATE
  ///

  Future<String?> _sendChatMessage(KChatMessage message) async {
    if (this.value.sendMessage == null) return Future.value();

    // Immediately update the messages for nice UI experience
    print("CHAT CTRL - inserting message locally localID:${message.localID}");
    this.value.messages?.insert(0, message);
    notifyListeners();

    print("CHAT CTRL - sending message by API");
    final fut = KStringHelper.isExist(this.value.chatID)
        ? this.value.sendMessage!(message: message)
        : this.value.sendMessage!(
            message: message,
            refPUIDs: this.value.members?.map((m) => m.puid!).toList(),
          );
    final response = await fut;

    String? chatID;
    if (response.isError) {
      print("CHAT CTRL - ERROR, removing local msg");
      this.value.messages?.removeWhere((c) => c.localID == message.localID);
      notifyListeners();
      return Future.value(null);
    } else if (response.isSuccess) {
      print("CHAT CTRL - SUCCESS, updating local chatID");
      chatID = response.chatMessage?.chatID;
      if (chatID != null) this.value.chatID = response.chatMessage?.chatID;
    }

    // Set chat id so it can be matched up with server data later on
    print("CHAT CTRL - update local msg with true messageID");
    _updateLocalChatMessage(message.localID!, response.chatMessage!);
    notifyListeners();

    // print("this.value.messages.first;

    return chatID;
  }

  void _updateLocalChatMessage(String localID, KChatMessage trueMessage) {
    for (int i = 0; i < (this.value.messages ?? []).length; i++) {
      if (this.value.messages![i].localID == localID) {
        // Set the local chat id so it can be matched up with data returned by
        // loadChats in the future
        print(
            "setLocalChatMessageID - message with localID $localID had messageID set to ${trueMessage.messageID}");
        // Keep localID so that we know this message is NOT from loadChats
        this.value.messages![i] = trueMessage
          ..localID = this.value.messages![i].localID;
        break;
      }
    }
  }
}
