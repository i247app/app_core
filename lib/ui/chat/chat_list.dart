// import 'dart:async';
//
// import 'package:app_core/app_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:app_core/helper/local_notif_helper.dart';
// import 'package:app_core/helper/location_helper.dart';
// import 'package:app_core/helper/push_data_helper.dart';
// import 'package:app_core/helper/session_data.dart';
// import 'package:app_core/helper/util.dart';
// import 'package:app_core/model/chat.dart';
// import 'package:app_core/model/chat_member.dart';
// import 'package:app_core/model/push_data.dart';
// import 'package:app_core/model/user.dart';
// import 'package:app_core/network/server_handler.dart';
// import 'package:app_core/ui/chat/chat_screen.dart';
// import 'package:app_core/ui/chat/chat_contacts.dart';
// import 'package:app_core/ui/chat/widget/chat_icon.dart';
// import 'package:app_core/value/styles.dart';
// import 'package:app_core/widget/embed_manager.dart';
// import 'package:app_core/widget/user_avatar.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
// class ChatList extends StatefulWidget {
//   @override
//   _ChatListState createState() => _ChatListState();
// }
//
// class _ChatListState extends State<ChatList> {
//   static List<Chat>? _chats;
//   final SlidableController slideCtrl = SlidableController();
//
//   late StreamSubscription streamSub;
//
//   bool get isReady => _chats != null;
//
//   @override
//   void initState() {
//     super.initState();
//
//     requestPermissions();
//
//     this.streamSub = PushDataHelper.stream.listen(pushDataListener);
//
//     loadChats();
//   }
//
//   @override
//   void dispose() {
//     this.streamSub.cancel();
//     super.dispose();
//   }
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
//   void pushDataListener(PushData data) {
//     switch (data.app) {
//       case PushData.APP_CHAT_NOTIFY:
//         loadChats();
//         break;
//     }
//   }
//
//   void loadChats() async {
//     final response = await ServerHandler.getChats();
//     if (mounted) setState(() => _chats = response.chats ?? []);
//   }
//
//   void onRemoveChat(int chatIndex, Chat chat) async {
//     if (chat.chatID == null || _chats == null) return;
//
//     final response = await ServerHandler.removeChat(
//       chat.chatID!,
//       AppCoreChat.APP_CONTENT_CHAT,
//       null,
//     );
//
//     if (response.isSuccess) {
//       // Then show a snackbar.
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('\'${chat.title}\' chat has been removed')));
//       setState(() {
//         _chats!.removeAt(chatIndex);
//       });
//     }
//
//     setState(() {
//       _chats!.removeAt(chatIndex);
//     });
//   }
//
//   void onChatClick(Chat chat) {
//     print("Clicked on chat ${chat.chatID}");
//     final screen = ChatScreen(
//       chatID: chat.chatID,
//       members: chat.members!,
//       title: chat.title,
//     );
//
//     Navigator.of(context)
//         .push(MaterialPageRoute(builder: (_) => screen))
//         .whenComplete(loadChats);
//   }
//
//   void onCreateChatClick() async {
//     List<User>? result = await Navigator.of(context)
//         .push(MaterialPageRoute(builder: (ctx) => ChatContacts()));
//
//     if (result == null || result.length == 0) return;
//
//     final users = result;
//     users.add(SessionData.me!);
//
//     final members = users.map((u) => ChatMember.fromUser(u)).toList();
//
//     final screen = ChatScreen(chatID: null, members: members, title: "");
//     Navigator.of(context)
//         .push(MaterialPageRoute(builder: (_) => screen))
//         .whenComplete(loadChats);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final chatListing = ListView.builder(
//       padding: EdgeInsets.only(top: 10, bottom: 100),
//       itemCount: (_chats ?? []).length,
//       shrinkWrap: true,
//       primary: false,
//       itemBuilder: (_, i) {
//         final chat = _chats![i];
//
//         return Slidable(
//           key: Key(chat.chatID ?? ""),
//           controller: slideCtrl,
//           actionPane: SlidableDrawerActionPane(),
//           actionExtentRatio: 0.25,
//           child: _ChatListEntry(
//             chat,
//             onClick: onChatClick,
//           ),
//           dismissal: SlidableDismissal(
//             child: SlidableDrawerDismissal(),
//             onDismissed: (actionType) => this.onRemoveChat(i, chat),
//           ),
//           secondaryActions: <Widget>[
//             IconSlideAction(
//               caption: 'Delete',
//               color: Colors.red,
//               icon: Icons.delete,
//               onTap: () => this.onRemoveChat(i, chat),
//             ),
//           ],
//         );
//       },
//     );
//
//     final newChatAction = IconButton(
//       onPressed: onCreateChatClick,
//       icon: Icon(Icons.add_circle_rounded),
//       color: Styles.colorIcon,
//     );
//
//     final topRow = Container(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       child: Row(
//         children: [
//           if (!EmbedManager.of(context).isEmbed) BackButton(),
//           Container(
//             height: 40,
//             width: 40,
//             child: UserAvatar.me(),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               "Chats",
//               style: Styles.largeText.copyWith(fontWeight: Styles.semiBold),
//               textAlign: TextAlign.start,
//             ),
//           ),
//           newChatAction,
//         ],
//       ),
//     );
//
//     final emptyInbox = Center(
//       child: Text(
//         "Your inbox is empty",
//         textAlign: TextAlign.center,
//       ),
//     );
//
//     final content = Column(
//       children: [
//         topRow,
//         Divider(height: 1, color: Styles.colorDivider),
//         Expanded(
//           child: this.isReady
//               ? ((_chats ?? []).isEmpty ? emptyInbox : chatListing)
//               : Container(),
//         ),
//       ],
//     );
//
//     final scaffoldView = Scaffold(
//       body: SafeArea(child: content),
//       backgroundColor: Styles.white,
//     );
//
//     return EmbedManager.of(context).isEmbed ? SafeArea(child: content) : scaffoldView;
//   }
// }
//
// class _ChatListEntry extends StatelessWidget {
//   final Chat chat;
//   final Function(Chat) onClick;
//
//   const _ChatListEntry(this.chat, {required this.onClick});
//
//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           this.chat.title,
//           style: Styles.normalText
//               .copyWith(color: Styles.black, fontWeight: FontWeight.normal),
//           overflow: TextOverflow.ellipsis,
//         ),
//         SizedBox(height: 6),
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Flexible(
//               child: Text(
//                 this.chat.previewMessage ?? "-",
//                 style: Styles.detailText.copyWith(color: Styles.chatGrey),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//
//     final body = InkWell(
//       onTap: () => this.onClick.call(this.chat),
//       child: Container(
//         padding: EdgeInsets.all(10),
//         child: Row(children: <Widget>[
//           ChatIcon(chat: this.chat),
//           SizedBox(width: 16),
//           Expanded(child: content),
//           SizedBox(width: 16),
//           Text(
//             Util.timeAgo(this.chat.activeDate ?? ""),
//             style: TextStyle(color: Styles.darkGrey),
//           ),
//         ]),
//       ),
//     );
//
//     return body;
//   }
// }
