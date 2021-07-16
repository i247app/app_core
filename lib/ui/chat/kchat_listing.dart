import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/kpush_data_helper.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/kchat.dart';
import 'package:app_core/model/kpush_data.dart';
import 'package:app_core/ui/chat/widget/kchat_icon.dart';
import 'package:app_core/header/kstyles.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class KChatListing extends StatefulWidget {
  final Function()? loadChats;
  final Function(String chatID, String? refApp, String? refID)? removeChat;
  final Function(KChat chat)? onChatClick;

  KChatListing({
    this.loadChats,
    this.removeChat,
    this.onChatClick,
  });

  @override
  _KChatListingState createState() => _KChatListingState();
}

class _KChatListingState extends State<KChatListing> {
  static List<KChat>? _chats;
  final SlidableController slideCtrl = SlidableController();

  late StreamSubscription streamSub;

  bool get isReady => _chats != null;

  @override
  void initState() {
    super.initState();

    this.streamSub = KPushDataHelper.stream.listen(pushDataListener);

    loadChats();
  }

  @override
  void dispose() {
    this.streamSub.cancel();
    super.dispose();
  }

  void pushDataListener(KPushData data) {
    switch (data.app) {
      case KPushData.APP_CHAT_NOTIFY:
        loadChats();
        break;
    }
  }

  void loadChats() async {
    if (this.widget.loadChats == null) return;

    List<KChat>? chats = await this.widget.loadChats!();
    if (mounted) setState(() => _chats = chats ?? []);
  }

  void onRemoveChat(int chatIndex, KChat chat) async {
    if (chat.chatID == null || _chats == null || this.widget.removeChat == null)
      return;

    final response = await this.widget.removeChat!(
      chat.chatID!,
      KChat.APP_CONTENT_CHAT,
      null,
    );

    if (response) {
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
          child: _ChatListEntry(
            chat,
            onClick: this.widget.onChatClick == null
                ? (_) {}
                : this.widget.onChatClick!,
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
        Divider(height: 1, color: KStyles.colorDivider),
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

class _ChatListEntry extends StatelessWidget {
  final KChat chat;
  final Function(KChat) onClick;

  const _ChatListEntry(this.chat, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.chat.title,
          style: KStyles.normalText
              .copyWith(color: KStyles.black, fontWeight: FontWeight.normal),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                this.chat.previewMessage ?? "-",
                style: KStyles.detailText.copyWith(color: KStyles.chatGrey),
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
          KChatIcon(chat: this.chat),
          SizedBox(width: 16),
          Expanded(child: content),
          SizedBox(width: 16),
          Text(
            KUtil.timeAgo(this.chat.activeDate ?? ""),
            style: TextStyle(color: KStyles.darkGrey),
          ),
        ]),
      ),
    );

    return body;
  }
}
