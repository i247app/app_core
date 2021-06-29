import 'dart:async';
import 'dart:ffi';

import 'package:app_core/helper/session_data.dart';
import 'package:app_core/helper/util.dart';
import 'package:app_core/model/chat_member.dart';
import 'package:app_core/model/chat_message.dart';
import 'package:app_core/model/user.dart';
import 'package:app_core/other/no_overscroll.dart';
import 'package:app_core/ui/chat/widget/chat_bubble.dart';
import 'package:app_core/value/styles.dart';
import 'package:app_core/widget/keyboard_killer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatroomContext {
  String? chatID;
  String? refApp;
  String? refID;
  List<ChatMember>? members;
  List<ChatMessage>? chatMessages;
  bool? isInitializing;
  bool? isEnded;

  ChatroomContext.fromChatID(this.chatID)
      : this.refApp = ChatMessage.APP_CONTENT_CHAT;

  ChatroomContext.fromRefData({
    required this.refApp,
    required this.refID,
    this.members,
    this.chatMessages,
    this.isInitializing,
    this.isEnded,
  });

  ChatroomContext({
    this.chatID,
    this.refApp,
    this.refID,
    this.members,
    this.chatMessages,
    this.isInitializing,
    this.isEnded,
  });
}

class Chatroom extends StatefulWidget {
  static const int MAX_MESSAGE_COUNT = 100;

  final ValueNotifier<ChatroomContext> controller;

  String? get chatID => this.controller.value.chatID;

  String? get refApp => this.controller.value.refApp;

  String? get refID => this.controller.value.refID;

  List<ChatMember>? get members => this.controller.value.members;

  List<ChatMessage>? get chatMessages => this.controller.value.chatMessages;

  bool? get isInitializing => this.controller.value.isInitializing;

  bool? get isEnded => this.controller.value.isEnded;

  final Function(String)? onOtherPersonClick;
  final Function()? onAddGalleryImageClick;
  final Function()? onAddCameraImageClick;
  final Function(String) sendText;

  const Chatroom(
      {required this.controller,
      this.onOtherPersonClick,
      this.onAddGalleryImageClick,
      this.onAddCameraImageClick,
      required this.sendText});

  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> with WidgetsBindingObserver {
  final messageCtrl = TextEditingController();

  List<ChatMessage> get chatMessages => this.widget.chatMessages ?? [];

  bool get isInitializing => this.widget.isInitializing ?? false;

  bool get hasSaidHiToPapa => this
      .chatMessages
      .where((cm) => cm.puid == SessionData.me?.puid)
      .isNotEmpty;

  bool get shouldSayHiToPapa => !this.hasSaidHiToPapa;

  bool get isEnded => this.widget.isEnded ?? false;

  User? get refUser =>
      (widget.members ?? [])
          .firstWhereOrNull((m) => m.puid != SessionData.me!.puid)
          ?.toUser() ??
      User();

  void onSendTextClick() async {
    final String sanitized = messageCtrl.text.trim();
    if (sanitized.isEmpty) return;

    messageCtrl.clear();
    this.widget.sendText(sanitized);
  }

  @override
  Widget build(BuildContext context) {
    final sayHiToPapaBtn = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Say hi to ${this.refUser?.firstName}",
          style: Styles.largeXLText,
        ),
        SizedBox(height: 14),
        IconButton(
          onPressed: () =>
              this.widget.sendText("Hi ${this.refUser?.firstName}!"),
          icon: Center(
            child: Text("👋", style: TextStyle(fontSize: 58)),
          ),
          iconSize: 70,
        ),
        SizedBox(height: 40),
      ],
    );

    final chatListing = ListView.builder(
      padding: EdgeInsets.all(4),
      reverse: true,
      itemCount: (this.chatMessages).length + (this.shouldSayHiToPapa ? 1 : 0),
      shrinkWrap: true,
      primary: false,
      itemBuilder: (_, i) {
        final isFirstItem = i == this.chatMessages.length;
        if (this.shouldSayHiToPapa && isFirstItem) {
          return sayHiToPapaBtn;
        } else {
          final prev = i == 0 ? null : this.chatMessages[i - 1];
          final next = i == this.chatMessages.length - 1
              ? null
              : this.chatMessages[i + 1];
          return ChatBubble(
            this.chatMessages[i],
            previousChat: next,
            nextChat: prev,
            onAvatarClick: this.widget.onOtherPersonClick ?? (_) {},
          );
        }
      },
    );

    final chatBody = this.isInitializing
        ? Container()
        : SingleChildScrollView(
            reverse: true,
            physics: ScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                chatListing,
                if (this.isEnded)
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Session has ended",
                      style: Styles.detailText,
                    ),
                  ),
                SizedBox(height: 4),
              ],
            ),
          );

    final addCameraButton = IconButton(
      onPressed: this.widget.onAddCameraImageClick,
      icon: Icon(Icons.camera_alt),
      color: Styles.colorIcon,
    );

    final addImageButton = IconButton(
      onPressed: this.widget.onAddGalleryImageClick,
      icon: Icon(Icons.image_outlined),
      color: Styles.colorIcon,
    );

    final sendMessageButton = IconButton(
      onPressed: onSendTextClick,
      icon: Icon(Icons.send),
      color: Styles.colorIcon,
    );

    final messageInputBox = SafeArea(
      top: false,
      bottom: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addCameraButton,
          addImageButton,
          SizedBox(width: 2),
          Expanded(
            child: ScrollConfiguration(
              behavior: NoOverscroll(),
              child: TextField(
                controller: messageCtrl,
                readOnly: this.isEnded,
                enabled: !this.isEnded,
                minLines: 1,
                maxLines: 6,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                  // hintText: "Enter a message...",
                  hintText: "Aa",
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                textInputAction: TextInputAction.newline,
              ),
            ),
          ),
          SizedBox(width: 2),
          sendMessageButton,
        ],
      ),
    );

    final body = Column(
      children: [
        Expanded(child: chatBody),
        if (!this.isEnded) ...[
          Divider(height: 1, color: Styles.colorDivider),
          Container(
            padding: EdgeInsets.all(2),
            child: messageInputBox,
          ),
        ],
      ],
    );

    return KeyboardKiller(child: body);
  }
}
