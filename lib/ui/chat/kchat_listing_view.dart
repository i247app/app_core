import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:app_core/ui/chat/widget/kchat_icon.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class KChatListingView extends StatefulWidget {
  final KChatListingController controller;
  final Function(KChat chat)? onChatClick;

  KChatListingView(
    this.controller, {
    this.onChatClick,
  });

  @override
  _KChatListingViewState createState() => _KChatListingViewState();
}

class _KChatListingViewState extends State<KChatListingView> {
  late StreamSubscription streamSub;

  List<KChat>? get chats => widget.controller.value.chats;

  bool get isReady => chats != null;

  @override
  void initState() {
    super.initState();

    this.streamSub = KPushDataHelper.stream.listen(pushDataListener);

    this.widget.controller.addListener(chatListingListener);

    this.widget.controller.loadChats();
  }

  @override
  void dispose() {
    // this.widget.controller.removeListener(chatListingListener);
    this.streamSub.cancel();
    super.dispose();
  }

  void pushDataListener(KPushData data) {
    switch (data.app) {
      case KPushData.APP_CHAT_NOTIFY:
        this.widget.controller.loadChats();
        break;
    }
  }

  void chatListingListener() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final chatListing = ListView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 100),
      itemCount: (chats ?? []).length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (_, i) {
        final chat = chats![i];

        return Slidable(
          key: Key(chat.chatID ?? ""),
          child: _ChatListEntry(
            chat,
            onClick: this.widget.onChatClick == null
                ? (_) {}
                : this.widget.onChatClick!,
          ),
          startActionPane: ActionPane(
            motion: DrawerMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {
                this.widget.controller.removeChat(i, chat);
              },
            ),
            children: [],
          ),
          endActionPane: ActionPane(
            motion: DrawerMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                label: 'Delete',
                backgroundColor: Colors.red,
                icon: Icons.delete,
                onPressed: (context) => this.widget.controller.removeChat(i, chat),
                padding: EdgeInsets.symmetric(horizontal: 2),
              ),
            ],
          ),
        );
      },
    );

    final emptyInbox = Center(
      child: Text(
        "Your inbox is empty",
        textAlign: TextAlign.center,
      ),
    );

    final content = this.isReady
        ? ((chats ?? []).isEmpty ? emptyInbox : chatListing)
        : Container();

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
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                this.chat.previewMessage ?? "-",
                style: Theme.of(context).textTheme.bodyMedium,
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
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]),
      ),
    );

    return body;
  }
}
