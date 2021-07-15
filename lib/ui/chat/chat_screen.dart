// import 'dart:async';
//
// import 'package:app_core/app_core.dart';
// import 'package:app_core/value/assets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:app_core/helper/local_notif_helper.dart';
// import 'package:app_core/helper/location_helper.dart';
// import 'package:app_core/helper/session_data.dart';
// import 'package:app_core/helper/webrtc_helper.dart';
// import 'package:app_core/model/chat.dart';
// import 'package:app_core/model/chat_member.dart';
// import 'package:app_core/model/user.dart';
// import 'package:app_core/network/server_handler.dart';
// import 'package:app_core/ui/chat/chat_manager.dart';
// import 'package:app_core/ui/chat/chatroom.dart';
// import 'package:app_core/ui/chat/chat_contacts.dart';
// import 'package:app_core/ui/chat/service/chatroom_controller.dart';
// import 'package:app_core/ui/chat/service/chatroom_data.dart';
// import 'package:app_core/ui/voip/voip_call.dart';
// import 'package:app_core/value/styles.dart';
//
// class ChatScreen extends StatefulWidget {
//   final List<ChatMember>? members;
//   final String? chatID;
//   final String? title;
//
//   ChatScreen({this.members, this.chatID, this.title});
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   late final ChatroomController chatroomCtrl;
//
//   List<ChatMember> get members =>
//       this.chatroomCtrl.value.members ?? widget.members ?? [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     this.chatroomCtrl = ChatroomController(ChatroomData(
//       refApp: AppCoreChat.APP_CONTENT_CHAT,
//       chatID: widget.chatID,
//       chatTitle: widget.title,
//       members: widget.members,
//     ));
//
//     this.chatroomCtrl.addListener(chatroomListener);
//
//     requestPermissions(); // need perms before any api call
//
//     this.chatroomCtrl.loadChat();
//   }
//
//   @override
//   void dispose() {
//     this.chatroomCtrl.removeListener(chatroomListener);
//     super.dispose();
//   }
//
//   void chatroomListener() => setState(() {});
//
//   static Future<void> requestPermissions() async {
//     // ios
//     // try {
//     //   await AppTrackingTransparency.requestTrackingAuthorization();
//     // } catch (e) {}
//
//     // local and push ask for iOS
//     try {
//       await LocalNotifHelper.setupLocalNotifications();
//     } catch (e) {}
//
//     // setup location permission ask
//     try {
//       await LocationHelper.askForPermission();
//     } catch (e) {}
//
//     // audio and video - prep for receiving calls
//     // try {
//     //   await WebRTCHelper.askForPermissions();
//     // } catch (e) {}
//   }
//
//   static Future<void> requestWebRTCPermissions() async {
//     try {
//       await WebRTCHelper.askForPermissions();
//     } catch (e) {}
//   }
//
//   void onCallUser() async {
//     if (this.chatroomCtrl.value.chatID == null) {
//       // if no chat ID, we should wait until first message created
//       await this.chatroomCtrl.sendVideoCallEvent();
//     } else {
//       this.chatroomCtrl.sendVideoCallEvent();
//     }
//     startVoipCall();
//   }
//
//   void startVoipCall() async {
//     await requestWebRTCPermissions();
//     final others =
//         this.members.where((m) => m.puid != SessionData.me?.puid).toList();
//     final invitePUIDs = others.map((other) => other.puid!).toList();
//
//     print("MEMBERS - ${this.members.length}");
//
//     // final response = await ServerHandler.getUser(puid: invitePUIDs.first);
//     // final theRefUser = response.user;
//     final User? theRefUser = this
//         .members
//         .where((m) => m.puid != SessionData.me?.puid)
//         .first
//         .toUser();
//     final screen = VOIPCall.asSender(
//       theRefUser!,
//       invitePUIDs: invitePUIDs,
//       chatroomData: this.chatroomCtrl.value,
//       videoLogo: Assets.IMG_CHAO_LOGO_SMALL,
//     );
//
//     Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
//   }
//
//   void onAddMember() async {
//     List<User>? result = await Navigator.of(context)
//         .push(MaterialPageRoute(builder: (ctx) => ChatContacts()));
//
//     if (result == null || result.length == 0) return;
//
//     final response = await ServerHandler.addChatMembers(
//       this.chatroomCtrl.value.chatID!,
//       result.map((u) => u.puid!).toList(),
//       this.chatroomCtrl.value.refApp,
//       this.chatroomCtrl.value.refID,
//     );
//
//     if (response.isSuccess) {
//       print("MEMBERS BEFORE - ${this.members.length}");
//       setState(() => this.members.addAll(response.members!));
//       print("MEMBERS AFTER - ${this.members.length}");
//     }
//   }
//
//   void showVideoCallDialog() async {
//     final dialog = AlertDialog(
//       title: Text("Video Call"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextButton(
//             onPressed: () => onCallUser(),
//             style: TextButton.styleFrom(textStyle: Styles.normalText),
//             child: Text(widget.title ?? ""),
//           )
//         ],
//       ),
//     );
//
//     showDialog(context: context, builder: (ctx) => dialog);
//   }
//
//   void onManagerMember() async {
//     List<ChatMember>? members =
//         await Navigator.of(context).push(MaterialPageRoute(
//             builder: (ctx) => ChatManager(
//                   chatId: this.chatroomCtrl.value.chatID!,
//                   chatTitle: this.chatroomCtrl.value.chatTitle,
//                   members: this.chatroomCtrl.value.members!,
//                   refApp: this.chatroomCtrl.value.refApp,
//                   refID: this.chatroomCtrl.value.refID,
//                 )));
//     if ((members ?? []).length > 0) this.chatroomCtrl.loadChat();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final body = this.chatroomCtrl.value.isInitializing
//         ? Container()
//         : Chatroom(this.chatroomCtrl);
//
//     // final body = Chatroom(this.chatroomCtrl);
//
//     final addMemberAction = IconButton(
//       onPressed: () => this.onManagerMember(),
//       icon: Icon(Icons.group_add),
//       color: Styles.colorIcon,
//     );
//
//     final videoCallAction = IconButton(
//       onPressed: onCallUser,
//       icon: Icon(Icons.video_call),
//       color: Styles.colorIcon,
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 1,
//         backgroundColor: Colors.white,
//         title: InkWell(
//           onTap: () => this.onManagerMember(),
//           child: Text(this.chatroomCtrl.value.chatTitle ?? "Chat"),
//         ),
//         actions: <Widget>[videoCallAction, addMemberAction],
//       ),
//       body: body,
//     );
//   }
// }
