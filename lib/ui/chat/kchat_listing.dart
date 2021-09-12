import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_core/ui/chat/service/kchat_listing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/kpush_data_helper.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/kchat.dart';
import 'package:app_core/model/kpush_data.dart';
import 'package:app_core/ui/chat/widget/kchat_icon.dart';
import 'package:app_core/header/kstyles.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class KChatListing extends StatefulWidget {
  final KChatListingController controller;
  final Function(KChat chat)? onChatClick;

  KChatListing(
    this.controller, {
    this.onChatClick,
  });

  @override
  _KChatListingState createState() => _KChatListingState();
}

class _KChatListingState extends State<KChatListing> {
  final SlidableController slideCtrl = SlidableController();

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

  void chatListingListener() {
    print("chat list udapte");
    setState(() {});
  }

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
            onDismissed: (actionType) =>
                this.widget.controller.removeChat(i, chat),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => this.widget.controller.removeChat(i, chat),
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
              ? ((chats ?? []).isEmpty ? emptyInbox : chatListing)
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
          style: context.textTheme.subtitle1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                this.chat.previewMessage ?? "-",
                style: context.textTheme.bodyText2,
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
            style: context.textTheme.bodyText2,
          ),
        ]),
      ),
    );

    return body;
  }
}
