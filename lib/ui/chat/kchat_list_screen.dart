import 'dart:async';

import 'package:app_core/helper/kglobals.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/model/kchat.dart';
import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/ui/chat/kchat_contact_listing.dart';
import 'package:app_core/ui/chat/kchat_listing_view.dart';
import 'package:app_core/ui/chat/kchat_screen.dart';
import 'package:app_core/ui/chat/service/kchat_listing_controller.dart';
import 'package:app_core/ui/chat/service/kchat_listing_data.dart';
import 'package:app_core/ui/widget/kembed_manager.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';

class KChatListScreen extends StatefulWidget {
  final bool allowCreateChat;

  KChatListScreen({this.allowCreateChat = true});

  @override
  _KChatListScreenState createState() => _KChatListScreenState();
}

class _KChatListScreenState extends State<KChatListScreen> {
  late final KChatListingController chatListingCtrl;

  Widget activeWidget = Container(
    child: Icon(
      Icons.message_outlined,
      size: 120,
      color: Colors.black12,
    ),
  );

  @override
  void initState() {
    super.initState();

    chatListingCtrl = KChatListingController(KChatListingData(
      loadChats: loadChats,
      removeChat: removeChat,
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<KUser>> searchUsers(String? searchText) async {
    if ((searchText ?? "").isEmpty) {
      return Future.value([]);
    }

    final response = await KServerHandler.searchUsers(searchText!);
    if (response.kstatus == 100) {
      return response.users ?? [];
    }

    return [];
  }

  Future<List<KChat>> loadChats() async {
    final response = await KServerHandler.getChats();
    return response.chats ?? [];
  }

  Future<bool> removeChat(KChat chat, String? refApp, String? refID) async {
    final response = await KServerHandler.removeChat(
      chat.chatID!,
      refApp,
      refID,
    );

    if (response.isSuccess) {
      // Then show a snackbar.
      ScaffoldMessenger.of(kNavigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text('\'${chat.title}\' chat has been removed')));
    }

    return response.isSuccess;
  }

  void onChatClick(KChat chat, bool isTablet) async {
    if (isTablet) {
      final screen = KChatScreen(
        key: UniqueKey(),
        isEmbedded: true,
        chatID: chat.chatID,
        members: (chat.kMembers ?? []),
        title: chat.title,
        onChatroomControllerHeard: chatListingCtrl.loadChats,
      );

      setState(() => activeWidget = screen);
    } else {
      final screen = KChatScreen(
        chatID: chat.chatID,
        members: (chat.kMembers ?? []),
        title: chat.title,
      );
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => screen));
      chatListingCtrl.loadChats();
    }
  }

  void onCreateChatClick() async {
    final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => KChatContactListing(searchUsers)));
    if ((result ?? []).isEmpty) {
      return;
    }

    final users = [...result, KSessionData.me!];
    final members = users.map((u) => KChatMember.fromUser(u)).toList();

    final screen = KChatScreen(chatID: null, members: members);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => screen))
        .whenComplete(() => chatListingCtrl.loadChats());
  }

  Widget _buildSmallLayout(bool isTablet) {
    final newChatAction = IconButton(
      onPressed: onCreateChatClick,
      icon: Icon(
        Icons.add_circle_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    final topRow = Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          if (!KEmbedManager.of(context).isEmbed) BackButton(),
          Container(
            height: 40,
            child: KUserAvatar.me(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Chats",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 20),
              textAlign: TextAlign.start,
            ),
          ),
          if (widget.allowCreateChat) newChatAction,
        ],
      ),
    );

    final chatListing = KChatListingView(
      chatListingCtrl,
      onChatClick: (chat) => onChatClick(chat, isTablet),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        topRow,
        Container(
          width: double.infinity,
          height: 1,
          color: KStyles.colorDivider,
        ),
        Expanded(child: chatListing),
      ],
    );

    return body;
  }

  Widget _buildTabletLayout(bool isTablet) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Container(
            width: 320, // MediaQuery.of(context).size.width / 3,
            child: Material(
              elevation: 0.5,
              child: _buildSmallLayout(isTablet),
            ),
          ),
        ),
        Expanded(child: activeWidget),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide < KStyles.smallestSize) {
      body = _buildSmallLayout(false);
    } else {
      body = _buildTabletLayout(true);
    }

    return KEmbedManager.of(context).isEmbed
        ? body
        : Scaffold(body: SafeArea(child: body));
  }
}
