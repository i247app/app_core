import 'dart:async';

import 'package:app_core/helper/khost_config.dart';
import 'package:app_core/helper/klocation_helper.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kwebrtc_helper.dart';
import 'package:app_core/model/kchat.dart';
import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/model/kchat_message.dart';
import 'package:app_core/model/response/send_chat_message_response.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/ui/chat/kchat_contact_listing.dart';
import 'package:app_core/ui/chat/kchat_manager.dart';
import 'package:app_core/header/kassets.dart';
import 'package:app_core/header/kold_styles.dart';
import 'package:app_core/ui/chat/kchatroom.dart';
import 'package:app_core/ui/chat/service/kchatroom_controller.dart';
import 'package:app_core/ui/voip/kvoip_call.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KChatScreen extends StatefulWidget {
  final List<KChatMember>? members;
  final String? chatID;
  final String? title;
  final Function? onChat;
  final bool isEmbedded;
  final Function? onChatroomControllerHeard;

  KChatScreen({
    Key? key,
    this.members,
    this.chatID,
    this.title,
    this.onChat,
    this.isEmbedded = false,
    this.onChatroomControllerHeard,
  }) : super(key: key);

  @override
  _KChatScreenState createState() => _KChatScreenState();
}

class _KChatScreenState extends State<KChatScreen> {
  late KChatroomController chatroomCtrl;

  List<KChatMember> get members =>
      this.chatroomCtrl.value.members ?? widget.members ?? [];

  bool get isVideoCallEnabled =>
      !KHostConfig.isReleaseMode || this.members.length <= 2;

  @override
  void initState() {
    super.initState();

    this.chatroomCtrl = KChatroomController(
      refApp: KChat.APP_CONTENT_CHAT,
      chatID: widget.chatID,
      members: widget.members,
    );
    this.chatroomCtrl.addListener(chatroomListener);

    requestPermissions(); // need perms before any api call
  }

  @override
  void dispose() {
    this.chatroomCtrl.removeListener(chatroomListener);
    super.dispose();
  }

  Future<KChat?> getChat({
    String? chatID,
    String? refApp,
    String? refID,
  }) async {
    try {
      final response = await KServerHandler.getChat(
        chatID: chatID,
        refApp: refApp,
        refID: refID,
      );
      return response.chat;
    } catch (e) {}
    return Future.value();
  }

  Future<SendChatMessageResponse?> sendMessage({
    required KChatMessage message,
    List<String>? refPUIDs,
  }) async {
    print("refPUIDs: " + (refPUIDs ?? []).join(','));
    try {
      final response = await KServerHandler.sendMessage(
        message,
        refPUIDs: refPUIDs,
      );

      return response;
    } catch (e) {}

    return null;
  }

  void chatroomListener() {
    widget.onChatroomControllerHeard?.call();
    setState(() {});
  }

  static Future<void> requestPermissions() async {
    // ios
    // try {
    //   await AppTrackingTransparency.requestTrackingAuthorization();
    // } catch (e) {}

    // local and push ask for iOS
    try {
      // await KLocalNotifHelper.setupLocalNotifications();
    } catch (e) {}

    // setup location permission ask
    try {
      await KLocationHelper.askForPermission();
    } catch (e) {}

    // audio and video - prep for receiving calls
    // try {
    //   await WebRTCHelper.askForPermissions();
    // } catch (e) {}
  }

  static Future<void> requestWebRTCPermissions() async {
    try {
      await KWebRTCHelper.askForPermissions();
    } catch (e) {}
  }

  void onCallUser() async {
    if (this.chatroomCtrl.value.chatID == null) {
      // if no chat ID, we should wait until first message created
      await this.chatroomCtrl.sendVideoCallEvent();
    } else {
      this.chatroomCtrl.sendVideoCallEvent();
    }
    startVoipCall();
  }

  void startVoipCall() async {
    await requestWebRTCPermissions();
    final others =
        this.members.where((m) => m.puid != KSessionData.me?.puid).toList();
    final invitePUIDs = others.map((other) => other.puid!).toList();

    print("MEMBERS - ${this.members.length}");

    final KUser? theRefUser = this
        .members
        .where((m) => m.puid != KSessionData.me?.puid)
        .first
        .toUser();
    final screen = KVOIPCall.asSender(theRefUser!,
        invitePUIDs: invitePUIDs,
        chatroomCtrl: this.chatroomCtrl,
        videoLogo: KAssets.IMG_TRANSPARENCY);

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Future<List<KUser>> searchUsers(String? searchText) async {
    if ((searchText ?? "").isEmpty) {
      return Future.value([]);
    }

    final response = await KServerHandler.searchUsers(searchText!);
    if (response.kstatus == 100) return response.users ?? [];

    return [];
  }

  void onAddMember() async {
    List<KUser>? result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => KChatContactListing(this.searchUsers)));

    if (result == null || result.length == 0) return;

    final response = await KServerHandler.addChatMembers(
      chatID: this.chatroomCtrl.value.chatID!,
      refPUIDs: result.map((u) => u.puid!).toList(),
      refApp: this.chatroomCtrl.value.refApp,
      refID: this.chatroomCtrl.value.refID,
    );

    if (response.isSuccess) {
      print("MEMBERS BEFORE - ${this.members.length}");
      setState(() => this.members.addAll(response.members!));
      print("MEMBERS AFTER - ${this.members.length}");
    }
  }

  void onManagerMember() async {
    List<KChatMember>? members =
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => KChatManager(
                  chatId: this.chatroomCtrl.value.chatID!,
                  chatTitle: this.chatroomCtrl.value.chatTitle,
                  members: this.chatroomCtrl.value.members!,
                  refApp: this.chatroomCtrl.value.refApp,
                  refID: this.chatroomCtrl.value.refID,
                )));
    if ((members ?? []).length > 0) this.chatroomCtrl.loadChat();
  }

  @override
  Widget build(BuildContext context) {
    final body = KChatroom(this.chatroomCtrl);

    final addMemberAction = IconButton(
      onPressed: () => this.onManagerMember(),
      icon: Icon(Icons.group_add),
    );

    final videoCallAction = IconButton(
      onPressed: this.isVideoCallEnabled ? onCallUser : null,
      icon: Icon(Icons.video_call),
    );

    // If tablet not show back button
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide < KOldStyles.smallestSize || !widget.isEmbedded) {
      return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () => this.onManagerMember(),
            child: Text(this.chatroomCtrl.value.chatTitle ?? "Chat"),
          ),
          actions: <Widget>[
            if (this.isVideoCallEnabled) videoCallAction,
            addMemberAction
          ],
        ),
        body: body,
      );
    } else {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.black54.withAlpha(0x10),
                ),
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => this.onManagerMember(),
                    child: Text(
                      this.chatroomCtrl.value.chatTitle ?? "Chat",
                      style: KOldStyles.largeText,
                    ),
                  ),
                ),
                if (this.isVideoCallEnabled) videoCallAction,
                addMemberAction
              ],
            ),
          ),
          Expanded(child: body),
          Container(height: keyboardHeight < 60 ? 0 : keyboardHeight - 60)
        ],
      );
    }
  }
}
