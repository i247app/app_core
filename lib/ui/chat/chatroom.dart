import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/photo_helper.dart';
import 'package:app_core/helper/session_data.dart';
import 'package:app_core/model/chat_message.dart';
import 'package:app_core/model/user.dart';
import 'package:app_core/ui/chat/service/chatroom_controller.dart';
import 'package:app_core/ui/chat/service/chatroom_data.dart';
import 'package:app_core/ui/chat/widget/chat_bubble.dart';
import 'package:app_core/ui/chat/widget/user_profile_view.dart';
import 'package:app_core/header/styles.dart';
import 'package:app_core/helper/local_notif_helper.dart';
import 'package:app_core/helper/location_helper.dart';
import 'package:app_core/helper/push_data_helper.dart';
import 'package:app_core/model/push_data.dart';
import 'package:app_core/header/no_overscroll.dart';
import 'package:app_core/ui/widget/dialog/open_settings_dialog.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:collection/collection.dart';

class AppCoreChatroom extends StatefulWidget {
  final AppCoreChatroomController controller;
  final bool isReadOnly;
  final Function({String? puid})? getUsers;

  const AppCoreChatroom(
    this.controller, {
    this.isReadOnly = false,
    this.getUsers,
  });

  @override
  _AppCoreChatroomState createState() => _AppCoreChatroomState();
}

class _AppCoreChatroomState extends State<AppCoreChatroom>
    with WidgetsBindingObserver {
  final messageCtrl = TextEditingController();

  late StreamSubscription pushDataStreamSub;

  AppCoreChatroomData get chatData => widget.controller.value;

  List<AppCoreChatMessage> get chatMessages => this.chatData.messages ?? [];

  bool get hasSaidHiToPapa => chatMessages
      .where((cm) => cm.puid == AppCoreSessionData.me?.puid)
      .isNotEmpty;

  bool get shouldSayHiToPapa => !this.hasSaidHiToPapa;

  AppCoreUser? get refUser => (this.chatData.members ?? [])
      .firstWhereOrNull((m) => m.puid != AppCoreSessionData.me!.puid)
      ?.toUser();

  @override
  void initState() {
    super.initState();

    requestPermissions(); // need perms before any api call

    LocalNotifHelper.blockBanner(AppCorePushData.APP_CHAT_NOTIFY);

    this.pushDataStreamSub =
        AppCorePushDataHelper.stream.listen(pushDataListener);

    // widget.controller
    //     .addListener(() => widget.loadChat.call(widget.controller));
    widget.controller.addListener(() => setState(() {}));
    WidgetsBinding.instance?.addObserver(this);

    widget.controller.loadChat();
  }

  @override
  void dispose() {
    LocalNotifHelper.unblockBanner(AppCorePushData.APP_CHAT_NOTIFY);
    this.pushDataStreamSub.cancel();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) widget.controller.loadChat();
  }

  static Future<void> requestPermissions() async {
    // local and push ask for iOS
    try {
      await LocalNotifHelper.setupLocalNotifications();
    } catch (e) {}

    // setup location permission ask
    try {
      await AppCoreLocationHelper.askForPermission();
    } catch (e) {}
  }

  void pushDataListener(AppCorePushData pushData) {
    switch (pushData.app) {
      case AppCorePushData.APP_CHAT_NOTIFY:
        widget.controller.loadChat();
        break;
    }
  }

  void onAddGalleryImageClick() async {
    final result = await PhotoHelper.gallery();
    if (result.status == PhotoStatus.permission_error)
      showDialog(
        context: context,
        builder: (ctx) =>
            AppCoreOpenSettingsDialog(body: "Photo permissions are required"),
      );
    else
      widget.controller.sendImage(result);
  }

  void onAddCameraImageClick() async {
    final result = await PhotoHelper.camera();
    if (result.status == PhotoStatus.permission_error)
      showDialog(
        context: context,
        builder: (ctx) =>
            AppCoreOpenSettingsDialog(body: "Camera permissions are required"),
      );
    else
      widget.controller.sendImage(result);
  }

  void onSendTextClick() async {
    final String sanitized = this.messageCtrl.text.trim();
    if (sanitized.isEmpty) return;

    this.messageCtrl.clear();
    widget.controller.sendText(sanitized);
  }

  void onOtherPersonClick(String puid) {
    if (this.widget.getUsers == null) return;

    this.widget.getUsers!(puid: puid).then((r) => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (ctx) => AppCoreUserProfileView(user: r.user))));
  }

  @override
  Widget build(BuildContext context) {
    final sayHiToPapaBtn = widget.isReadOnly
        ? Container()
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Say hi to ${this.refUser?.firstName}",
                style: Styles.largeXLText,
              ),
              SizedBox(height: 14),
              IconButton(
                onPressed: () => widget.controller
                    .sendText("Hi ${this.refUser?.firstName}!"),
                icon: Center(child: Text("👋", style: TextStyle(fontSize: 58))),
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
          return AppCoreChatBubble(
            this.chatMessages[i],
            previousChat: next,
            nextChat: prev,
            onAvatarClick: onOtherPersonClick,
          );
        }
      },
    );

    final chatBody = SingleChildScrollView(
      reverse: true,
      physics: ScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          chatListing,
          if (widget.isReadOnly)
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
      onPressed: onAddCameraImageClick,
      icon: Icon(Icons.camera_alt),
      color: Styles.colorIcon,
    );

    final addImageButton = IconButton(
      onPressed: onAddGalleryImageClick,
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
                readOnly: widget.isReadOnly,
                enabled: !widget.isReadOnly,
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
        if (!widget.isReadOnly) ...[
          Divider(height: 1, color: Styles.colorDivider),
          Container(
            padding: EdgeInsets.all(2),
            child: messageInputBox,
          ),
        ],
      ],
    );

    return AppCoreKeyboardKiller(child: body);
  }
}
