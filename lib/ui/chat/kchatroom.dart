import 'dart:async';

import 'package:app_core/header/no_overscroll.dart';
import 'package:app_core/helper/klocal_notif_helper.dart';
import 'package:app_core/helper/kphoto_helper.dart';
import 'package:app_core/helper/kpush_data_helper.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/service/ktheme_service.dart';
import 'package:app_core/model/kchat_message.dart';
import 'package:app_core/model/kpush_data.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/ui/chat/service/kchatroom_controller.dart';
import 'package:app_core/ui/chat/service/kchatroom_data.dart';
import 'package:app_core/ui/chat/widget/kchat_bubble.dart';
import 'package:app_core/ui/chat/widget/kuser_view.dart';
import 'package:app_core/ui/widget/dialog/kopen_settings_dialog.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class KChatroom extends StatefulWidget {
  final KChatroomController controller;
  final bool isReadOnly;
  final bool isSupport;
  final bool isEnableTakePhoto;
  final bool ignorePapa;
  final List<String>? preTexts;
  final Function()? onSelectDoc;

  const KChatroom(
    this.controller, {
    this.isReadOnly = false,
    this.isSupport = false,
    this.isEnableTakePhoto = true,
    this.ignorePapa = false,
    this.onSelectDoc,
    this.preTexts,
  });

  @override
  _KChatroomState createState() => _KChatroomState();
}

class _KChatroomState extends State<KChatroom> with WidgetsBindingObserver {
  final messageCtrl = TextEditingController();
  final scrollCtrl = ScrollController();

  late StreamSubscription pushDataStreamSub;

  KChatroomData get chatData => widget.controller.value;

  List<KChatMessage> get chatMessages => this.chatData.messages ?? [];

  bool get hasSaidHiToPapa =>
      chatMessages.where((cm) => cm.puid == KSessionData.me?.puid).isNotEmpty;

  bool get shouldSayHiToPapa => !widget.ignorePapa && !hasSaidHiToPapa;

  KUser? get refUser => (widget.controller.members() ?? [])
      .firstWhereOrNull((m) => m.puid != KSessionData.me!.puid)
      ?.toUser();

  bool get showInputBoxDivider {
    try {
      return !(scrollCtrl.position.atEdge && scrollCtrl.position.pixels == 0);
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    KLocalNotifHelper.blockBanner(KPushData.APP_CHAT_NOTIFY);

    pushDataStreamSub = KPushDataHelper.stream.listen(pushDataListener);

    messageCtrl.addListener(basicSetStateListener);
    widget.controller.addListener(basicSetStateListener);

    WidgetsBinding.instance.addObserver(this);

    widget.controller.loadChat();
  }

  @override
  void dispose() {
    messageCtrl.removeListener(basicSetStateListener);
    widget.controller.removeListener(basicSetStateListener);
    KLocalNotifHelper.unblockBanner(KPushData.APP_CHAT_NOTIFY);
    this.pushDataStreamSub.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) widget.controller.loadChat();
  }

  void basicSetStateListener() => setState(() {});

  void pushDataListener(KPushData pushData) {
    switch (pushData.app) {
      case KPushData.APP_CHAT_NOTIFY:
        widget.controller.loadChat();
        break;
    }
  }

  void onAddGalleryImageClick() async {
    final result = await KPhotoHelper.gallery();
    if (result.status == KPhotoStatus.permission_error) {
      showDialog(
        context: context,
        builder: (ctx) =>
            KOpenSettingsDialog(body: "Photo permissions are required"),
      );
    } else {
      widget.controller.sendImage(result);
    }
  }

  void onAddCameraImageClick() async {
    // TODO: Camera permission

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

  void onOtherPersonClick(KUser user) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => KUserView.fromUser(user)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sayHiToPapaBtn = widget.isReadOnly
        ? Container()
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${KPhrases.sayHiToX} ${widget.isSupport ? "customer support" : refUser?.firstName}",
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14),
              IconButton(
                onPressed: () => widget.controller.sendText(
                    "${KPhrases.hi} ${widget.isSupport ? "" : refUser?.firstName!}"),
                icon: Center(child: Text("👋", style: TextStyle(fontSize: 58))),
                iconSize: 70,
              ),
              SizedBox(height: 40),
            ],
          );

    final chatListing = ListView.builder(
      padding: EdgeInsets.all(4),
      reverse: true,
      itemCount: (this.chatMessages).length + (shouldSayHiToPapa ? 1 : 0),
      shrinkWrap: true,
      primary: false,
      itemBuilder: (_, i) {
        final isFirstItem = i == this.chatMessages.length;
        if (this.shouldSayHiToPapa && isFirstItem) {
          print("widget.ignorePapa - ${widget.ignorePapa}");
          return sayHiToPapaBtn;
        } else {
          final prev = i == 0 ? null : this.chatMessages[i - 1];
          final next = i == this.chatMessages.length - 1
              ? null
              : this.chatMessages[i + 1];
          return KChatBubble(
            this.chatMessages[i],
            onReload: () => setState(() {}),
            members: chatData.members,
            previousMsg: next,
            nextMsg: prev,
            onAvatarClick: onOtherPersonClick,
          );
        }
      },
    );

    final preTextView = widget.preTexts == null
        ? null
        : widget.preTexts!
            .map<Widget>(
              (text) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  onTap: () {
                    widget.controller.sendText(text);
                  },
                  child: Chip(
                    label: Text(text),
                  ),
                ),
              ),
            )
            .toList();

    final chatBody = SingleChildScrollView(
      controller: scrollCtrl,
      reverse: true,
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      // physics: ScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          chatListing,
          if (preTextView != null)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: preTextView,
              ),
            ),
          if (widget.isReadOnly)
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Session has ended",
                style: theme.textTheme.bodyLarge,
              ),
            ),
        ],
      ),
    );

    final addCameraButton = IconButton(
      onPressed: onAddCameraImageClick,
      icon: Icon(
        Icons.camera_alt,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    final addImageButton = IconButton(
      onPressed: onAddGalleryImageClick,
      icon: Icon(
        Icons.image_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    final addTextbookButton = IconButton(
      onPressed: widget.onSelectDoc,
      icon: Icon(
        Icons.file_copy_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    final sendMessageButton = IconButton(
      onPressed: onSendTextClick,
      icon: Icon(
        Icons.send,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    final sendLikeButton = IconButton(
      onPressed: () => widget.controller.sendText("👍"),
      icon: Icon(
        Icons.thumb_up,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    final isDarkMode = KThemeService.isDarkMode();

    final inputBox = SafeArea(
      top: false,
      bottom: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.isEnableTakePhoto && widget.controller.isCameraAllowed)
            addCameraButton,
          if (widget.controller.isGalleryAllowed) addImageButton,
          if (widget.onSelectDoc != null) addTextbookButton,
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
                  fillColor: isDarkMode ? Colors.white30 : Colors.black12,
                  hintText: "Aa",
                  filled: true,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                textInputAction: TextInputAction.newline,
              ),
            ),
          ),
          SizedBox(width: 2),
          (messageCtrl.text.isEmpty && widget.controller.isThumbAllowed)
              ? sendLikeButton
              : sendMessageButton,
        ],
      ),
    );

    final body = Column(
      children: [
        Expanded(child: chatBody),
        if (!widget.isReadOnly) ...[
          Container(
            height: 1,
            color: showInputBoxDivider ? Colors.black12 : Colors.transparent,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: inputBox,
          ),
        ],
      ],
    );

    return this.chatData.isInitializing
        ? Container()
        : KeyboardKiller(child: body);
  }
}
