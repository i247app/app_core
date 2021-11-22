import 'dart:async';

import 'package:app_core/helper/kglobals.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/model/kchat.dart';
import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/ui/chat/kchat_contact_listing.dart';
import 'package:app_core/ui/chat/kchat_listing.dart';
import 'package:app_core/ui/chat/service/kchat_listing_controller.dart';
import 'package:app_core/ui/chat/service/kchat_listing_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/ui/chat/kchat_screen.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:app_core/ui/widget/kembed_manager.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';

class KChatListScreen extends StatefulWidget {
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

    this.chatListingCtrl = KChatListingController(KChatListingData(
      loadChats: this.loadChats,
      removeChat: this.removeChat,
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
    if (response.kstatus == 100) return response.users ?? [];

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

    if (response.isSuccess)
      // Then show a snackbar.
      ScaffoldMessenger.of(kNavigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text('\'${chat.title}\' chat has been removed')));

    return response.isSuccess;
  }

  void onChatClick(KChat chat, bool isTablet) async {
    print("Clicked on chat ${chat.chatID}");

    if (isTablet) {
      final screen = KChatScreen(
        key: UniqueKey(),
        isEmbedded: true,
        chatID: chat.chatID,
        members: (chat.kMembers ?? []),
        title: chat.title,
        onChatroomControllerHeard: this.chatListingCtrl.loadChats,
      );

      setState(() => this.activeWidget = screen);
    } else {
      final screen = KChatScreen(
        chatID: chat.chatID,
        members: (chat.kMembers ?? []),
        title: chat.title,
      );
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => screen));
      this.chatListingCtrl.loadChats();
    }
  }

  void onCreateChatClick() async {
    List<KUser>? result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => KChatContactListing(this.searchUsers)));

    if (result == null || result.length == 0) return;

    final users = result;
    users.add(KSessionData.me!);

    final members = users.map((u) => KChatMember.fromUser(u)).toList();

    final screen = KChatScreen(chatID: null, members: members, title: "");
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    this.chatListingCtrl.loadChats();
  }

  Widget _buildSmallLayout(bool isTablet) {
    final newChatAction = IconButton(
      onPressed: onCreateChatClick,
      icon: Icon(Icons.add_circle_rounded),
    );

    final topRow = Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (!KEmbedManager.of(context).isEmbed) BackButton(),
          Container(
            height: 40,
            width: 40,
            child: KUserAvatar.me(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Chats",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
          ),
          newChatAction,
        ],
      ),
    );

    final chatListing = KChatListing(
      this.chatListingCtrl,
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
        Expanded(child: this.activeWidget),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget content;
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide < KStyles.smallestSize) {
      content = _buildSmallLayout(false);
    } else {
      content = _buildTabletLayout(true);
    }

    final scaffoldView = Scaffold(
      body: SafeArea(child: content),
    );

    return KEmbedManager.of(context).isEmbed ? content : scaffoldView;
  }
}
