import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:flutter/widgets.dart';

enum KChatMedia { CAMERA, GALLERY, TEXT, THUMB }

class KChatroomController extends ValueNotifier<KChatroomData> {
  static const int MAX_MESSAGE_COUNT = 100;

  final String? _chatID;
  final String? _refApp;
  final String? _refID;
  final List<KChatMember>? _members;
  final void Function(KChatMessage)? sendOverrideCallback;
  final List<KChatMedia>? allowedMedia;

  String? get _smartChatID => this._chatID ?? this.value.chatID;

  String? get _smartRefApp => this._refApp ?? this.value.refApp;

  String? get _smartRefID => this._refID ?? this.value.refID;

  List<KChatMember>? get _smartMembers => this._members ?? this.value.members;

  bool get isCameraAllowed => allowedMedia?.contains(KChatMedia.CAMERA) ?? true;

  bool get isGalleryAllowed =>
      allowedMedia?.contains(KChatMedia.GALLERY) ?? true;

  bool get isTextAllowed => allowedMedia?.contains(KChatMedia.TEXT) ?? true;

  bool get isThumbAllowed => allowedMedia?.contains(KChatMedia.THUMB) ?? true;

  List<KChatMember>? members() => _smartMembers;

  KChatMessage get messageTemplate => KChatMessage()
    ..chatID = this._smartChatID
    ..localID = KChatMessage.generateLocalID()
    ..puid = KSessionData.me?.puid
    ..refApp = this._smartRefApp
    ..refID = this._smartRefID
    ..messageDate = DateTime.now();

  KChatroomController({
    String? chatID,
    String? refApp,
    String? refID,
    List<KChatMember>? members,
    this.sendOverrideCallback,
    this.allowedMedia,
  })  : this._chatID = chatID,
        this._refApp = refApp,
        this._refID = refID,
        this._members = members,
        super(KChatroomData(
            chatID: chatID, members: members, refApp: refApp, refID: refID));

  Future<String?> sendVideoCallEvent() async => sendMessage(
        messageType: KChatMessage.CONTENT_TYPE_VIDEO_CALL_EVENT,
        text: "Video call ${KUtil.prettyDate(DateTime.now())}",
      );

  Future<String?> sendChapter(String chapterID) async => sendMessage(
        messageType: KChatMessage.CONTENT_TYPE_CHAPTER,
        text: chapterID,
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
    final response = await KServerHandler.getChat(
      chatID: this._smartChatID,
      refApp: this._smartRefApp,
      refID: this._smartRefID,
    );
    this.value.response = response;
    this.value.messages ??= [];
    if (this.value.members == null) {
      this.value.members ??= [];
    }

    if (response.isError || response.chat?.kMessages == null) {
      notifyListeners();
      return;
    }

    // Merge algorithm
    final List<String> msgIdsForDeletion = [];
    for (var it1 = this.value.messages!.iterator; it1.moveNext();) {
      for (var it2 = response.chat!.kMessages!.iterator; it2.moveNext();) {
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

    this.value.messages!.addAll(response.chat!.kMessages!);
    if (response.chat!.kMembers!.length > 0) {
      this.value.members!.clear();
      this.value.members!.addAll(response.chat!.kMembers!);
    }

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

    if (this._smartChatID == null && (this.value.messages?.length ?? 0) > 0) {
      this.value.chatID = this.value.messages?.first.chatID;
    }

    notifyListeners();
  }

  void addMembers(List<String> memberPUIDs) async {
    final response = await KServerHandler.addChatMembers(
      chatID: this._smartChatID!,
      refPUIDs: memberPUIDs,
      refApp: this._smartRefApp,
      refID: this._smartRefID,
    );

    if (response.isSuccess) {
      if (this.value.members == null) {
        this.value.members = response.members;
      } else {
        this.value.members?.addAll(response.members!);
      }

      notifyListeners();
    }
  }

  ///
  /// PRIVATE
  ///
  Future<String?> _sendChatMessage(KChatMessage message) async {
    // Immediately update the messages for nice UI experience
    // print("CHAT CTRL - inserting message locally localID:${message.localID}");
    this.value.messages?.insert(0, message);
    notifyListeners();

    if (sendOverrideCallback != null) {
      sendOverrideCallback?.call(message);
      return Future.value();
    }

    // print("CHAT CTRL - sending message by API");
    final fut = (this.value.chatID ?? "").isNotEmpty
        ? KServerHandler.sendMessage(message)
        : KServerHandler.sendMessage(
            message,
            refPUIDs: this._smartMembers?.map((m) => m.puid!).toList(),
          );
    final response = await fut;

    String? chatID;
    if (response.isError) {
      // print("CHAT CTRL - ERROR, removing local msg");
      this.value.messages?.removeWhere((c) => c.localID == message.localID);
      notifyListeners();
      return Future.value(null);
    } else if (response.isSuccess) {
      // print("CHAT CTRL - SUCCESS, updating local chatID");
      chatID = response.chatMessage?.chatID;
      if (chatID != null) this.value.chatID = response.chatMessage?.chatID;
    }

    // Set chat id so it can be matched up with server data later on
    // print("CHAT CTRL - update local msg with true messageID");
    _reconcileLocalChatMessage(message.localID!, response.chatMessage!);
    notifyListeners();

    return chatID;
  }

  void _reconcileLocalChatMessage(String localID, KChatMessage trueMessage) {
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
