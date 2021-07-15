import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/local_notif_helper.dart';
import 'package:app_core/helper/location_helper.dart';
import 'package:app_core/helper/push_data_helper.dart';
import 'package:app_core/helper/session_data.dart';
import 'package:app_core/helper/util.dart';
import 'package:app_core/model/chat.dart';
import 'package:app_core/model/chat_member.dart';
import 'package:app_core/model/push_data.dart';
import 'package:app_core/model/user.dart';
import 'package:app_core/ui/chat/chat_contacts.dart';
import 'package:app_core/ui/chat/widget/chat_icon.dart';
import 'package:app_core/header//styles.dart';
import 'package:app_core/ui/widget/user_avatar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AppCoreChatListing extends StatefulWidget {
  Function()? loadChats;
  Function(String chatID, String? refApp, String? refID)? removeChat;
  Function(AppCoreChat chat)? onChatClick;

  AppCoreChatListing({
    this.loadChats,
    this.removeChat,
    this.onChatClick,
  });

  @override
  _AppCoreChatListingState createState() => _AppCoreChatListingState();
}

class _AppCoreChatListingState extends State<AppCoreChatListing> {
  static List<AppCoreChat>? _chats;
  final SlidableController slideCtrl = SlidableController();

  late StreamSubscription streamSub;

  bool get isReady => _chats != null;

  @override
  void initState() {
    super.initState();

    requestPermissions();

    this.streamSub = AppCorePushDataHelper.stream.listen(pushDataListener);

    loadChats();
  }

  @override
  void dispose() {
    this.streamSub.cancel();
    super.dispose();
  }

  static Future<void> requestPermissions() async {
    // ios
    // try {
    //   await AppTrackingTransparency.requestTrackingAuthorization();
    // } catch (e) {}

    // local and push ask for iOS
    try {
      await AppCoreLocalNotifHelper.setupLocalNotifications();
    } catch (e) {}

    // setup location permission ask
    try {
      await AppCoreLocationHelper.askForPermission();
    } catch (e) {}

    // audio and video - prep for receiving calls
    // try {
    //   await WebRTCHelper.askForPermissions();
    // } catch (e) {}
  }

  void pushDataListener(AppCorePushData data) {
    switch (data.app) {
      case AppCorePushData.APP_CHAT_NOTIFY:
        loadChats();
        break;
    }
  }

  void loadChats() async {
    if (this.widget.loadChats == null) return;

    List<AppCoreChat> chats = await this.widget.loadChats!();
    if (mounted) setState(() => _chats = chats ?? []);
  }

  void onRemoveChat(int chatIndex, AppCoreChat chat) async {
    if (chat.chatID == null || _chats == null || this.widget.removeChat == null) return;

    final response = await this.widget.removeChat!(
      chat.chatID!,
      AppCoreChat.APP_CONTENT_CHAT,
      null,
    );

    if (response.isSuccess) {
      // Then show a snackbar.
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('\'${chat.title}\' chat has been removed')));
      setState(() {
        _chats!.removeAt(chatIndex);
      });
    }

    setState(() {
      _chats!.removeAt(chatIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatListing = ListView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 100),
      itemCount: (_chats ?? []).length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (_, i) {
        final chat = _chats![i];

        return Slidable(
          key: Key(chat.chatID ?? ""),
          controller: slideCtrl,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: _AppCoreChatListEntry(
            chat,
            onClick: this.widget.onChatClick == null ? () {} : this.widget.onChatClick!(chat),
          ),
          dismissal: SlidableDismissal(
            child: SlidableDrawerDismissal(),
            onDismissed: (actionType) => this.onRemoveChat(i, chat),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => this.onRemoveChat(i, chat),
            ),
          ],
        );
      },
    );

    final emptyInbox = Center(
      child: Text(
        "Your inbox is empty",
        textAlign: TextAlign.center,
      ),
    );

    final content = Column(
      children: [
        Divider(height: 1, color: Styles.colorDivider),
        Expanded(
          child: this.isReady
              ? ((_chats ?? []).isEmpty ? emptyInbox : chatListing)
              : Container(),
        ),
      ],
    );

    return content;
  }
}

class _AppCoreChatListEntry extends StatelessWidget {
  final AppCoreChat chat;
  final Function(AppCoreChat) onClick;

  const _AppCoreChatListEntry(this.chat, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.chat.title,
          style: Styles.normalText
              .copyWith(color: Styles.black, fontWeight: FontWeight.normal),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                this.chat.previewMessage ?? "-",
                style: Styles.detailText.copyWith(color: Styles.chatGrey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );

    final body = InkWell(
      onTap: () => this.onClick.call(this.chat),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(children: <Widget>[
          AppCoreChatIcon(chat: this.chat),
          SizedBox(width: 16),
          Expanded(child: content),
          SizedBox(width: 16),
          Text(
            AppCoreUtil.timeAgo(this.chat.activeDate ?? ""),
            style: TextStyle(color: Styles.darkGrey),
          ),
        ]),
      ),
    );

    return body;
  }
}
