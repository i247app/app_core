import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/kphoto_helper.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/model/kchat_message.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/ui/chat/service/kchatroom_controller.dart';
import 'package:app_core/ui/chat/service/kchatroom_data.dart';
import 'package:app_core/ui/chat/widget/kchat_bubble.dart';
import 'package:app_core/ui/chat/widget/kuser_profile_view.dart';
import 'package:app_core/header/kstyles.dart';
import 'package:app_core/helper/klocal_notif_helper.dart';
import 'package:app_core/helper/kpush_data_helper.dart';
import 'package:app_core/model/kpush_data.dart';
import 'package:app_core/header/no_overscroll.dart';
import 'package:app_core/ui/widget/dialog/kopen_settings_dialog.dart';
import 'package:app_core/ui/widget/kkeyboard_killer.dart';
import 'package:collection/collection.dart';

class KChatroom extends StatefulWidget {
  final KChatroomController controller;
  final bool isReadOnly;
  final Function({String? puid})? getUsers;

  const KChatroom(
    this.controller, {
    this.isReadOnly = false,
    this.getUsers,
  });

  @override
  _KChatroomState createState() => _KChatroomState();
}

class _KChatroomState extends State<KChatroom> with WidgetsBindingObserver {
  final messageCtrl = TextEditingController();

  late StreamSubscription pushDataStreamSub;

  KChatroomData get chatData => widget.controller.value;

  List<KChatMessage> get chatMessages => this.chatData.messages ?? [];

  bool get hasSaidHiToPapa =>
      chatMessages.where((cm) => cm.puid == KSessionData.me?.puid).isNotEmpty;

  bool get shouldSayHiToPapa => !this.hasSaidHiToPapa;

  KUser? get refUser => (this.chatData.members ?? [])
      .firstWhereOrNull((m) => m.puid != KSessionData.me!.puid)
      ?.toUser();

  @override
  void initState() {
    super.initState();
    KLocalNotifHelper.blockBanner(KPushData.APP_CHAT_NOTIFY);

    this.pushDataStreamSub = KPushDataHelper.stream.listen(pushDataListener);

    // widget.controller
    //     .addListener(() => widget.loadChat.call(widget.controller));
    widget.controller.addListener(() => setState(() {}));
    WidgetsBinding.instance?.addObserver(this);

    widget.controller.loadChat();
  }

  @override
  void dispose() {
    KLocalNotifHelper.unblockBanner(KPushData.APP_CHAT_NOTIFY);
    this.pushDataStreamSub.cancel();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) widget.controller.loadChat();
  }

  void pushDataListener(KPushData pushData) {
    switch (pushData.app) {
      case KPushData.APP_CHAT_NOTIFY:
        widget.controller.loadChat();
        break;
    }
  }

  void onAddGalleryImageClick() async {
    final result = await KPhotoHelper.gallery();
    if (result.status == KPhotoStatus.permission_error)
      showDialog(
        context: context,
        builder: (ctx) =>
            KOpenSettingsDialog(body: "Photo permissions are required"),
      );
    else
      widget.controller.sendImage(result);
  }

  void onAddCameraImageClick() async {
    final result = await KPhotoHelper.camera();
    if (result.status == KPhotoStatus.permission_error)
      showDialog(
        context: context,
        builder: (ctx) =>
            KOpenSettingsDialog(body: "Camera permissions are required"),
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
            builder: (ctx) => UserProfileView(user: r.user))));
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
                style: KStyles.largeXLText,
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
          return KChatBubble(
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
                style: KStyles.detailText,
              ),
            ),
          SizedBox(height: 4),
        ],
      ),
    );

    final addCameraButton = IconButton(
      onPressed: onAddCameraImageClick,
      icon: Icon(Icons.camera_alt),
      color: KStyles.colorIcon,
    );

    final addImageButton = IconButton(
      onPressed: onAddGalleryImageClick,
      icon: Icon(Icons.image_outlined),
      color: KStyles.colorIcon,
    );

    final sendMessageButton = IconButton(
      onPressed: onSendTextClick,
      icon: Icon(Icons.send),
      color: KStyles.colorIcon,
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
          Divider(height: 1, color: KStyles.colorDivider),
          Container(
            padding: EdgeInsets.all(2),
            child: messageInputBox,
          ),
        ],
      ],
    );

    return this.chatData.isInitializing ? Container() : KeyboardKiller(child: body);
  }
}
