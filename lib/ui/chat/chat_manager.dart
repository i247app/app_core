// import 'package:app_core/helper/session_data.dart';
// import 'package:app_core/helper/string_helper.dart';
// import 'package:app_core/model/chat_member.dart';
// import 'package:app_core/model/user.dart';
// import 'package:app_core/network/server_handler.dart';
// import 'package:app_core/ui/chat/chat_contacts.dart';
// import 'package:app_core/value/styles.dart';
// import 'package:app_core/widget/chat_display_name.dart';
// import 'package:app_core/widget/keyboard_killer.dart';
// import 'package:app_core/widget/user_avatar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
// class ChatManager extends StatefulWidget {
//   final String chatId;
//   final String? chatTitle;
//   final String? refID;
//   final String? refApp;
//   final List<ChatMember> members;
//
//   const ChatManager({
//     Key? key,
//     required this.chatId,
//     required this.members,
//     this.refID,
//     this.refApp,
//     this.chatTitle,
//   }) : super(key: key);
//
//   @override
//   _ChatManagerState createState() => _ChatManagerState();
// }
//
// class _ChatManagerState extends State<ChatManager> {
//   List<ChatMember> members = [];
//   final SlidableController slidableController = SlidableController();
//   final FocusNode focusNode = FocusNode();
//   final groupNameCtrl = TextEditingController();
//
//   bool isEditGroupName = false;
//
//   @override
//   void initState() {
//     super.initState();
//     members.addAll(widget.members);
//
//     if (StringHelper.isExist(this.widget.chatTitle)) {
//       this.groupNameCtrl.text = this.widget.chatTitle!;
//     }
//   }
//
//   void onRemoveMember(int memberIndex, ChatMember member) async {
//     final response = await ServerHandler.removeChatMembers(
//       this.widget.chatId,
//       StringHelper.isExist(member.puid) ? [member.puid!] : [],
//       this.widget.refApp,
//       this.widget.refID,
//     );
//
//     if (response.isSuccess) {
//       // Then show a snackbar.
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('${member.firstName} has been removed from chat')));
//       setState(() {
//         members.removeAt(memberIndex);
//       });
//     }
//   }
//
//   void onAddMember() async {
//     List<User>? result = await Navigator.of(context)
//         .push(MaterialPageRoute(builder: (ctx) => ChatContacts()));
//
//     if (result == null || result.length == 0) return;
//
//     final response = await ServerHandler.addChatMembers(
//       this.widget.chatId,
//       result.map((u) => u.puid!).toList(),
//       this.widget.refApp,
//       this.widget.refID,
//     );
//
//     if (response.isSuccess) {
//       print("MEMBERS BEFORE - ${this.members.length}");
//       setState(() => this.members.addAll(response.members!));
//       print("MEMBERS AFTER - ${this.members.length}");
//     }
//   }
//
//   void onEditGroupName() {
//     this.setState(() {
//       this.isEditGroupName = true;
//     });
//   }
//
//   void onChangeGroupName() {
//     this.setState(() {
//       this.isEditGroupName = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final list = ListView.separated(
//       padding: EdgeInsets.all(4),
//       itemCount: members.length + 1,
//       itemBuilder: (_, i) {
//         if (i == members.length) {
//           return Container(
//             padding: EdgeInsets.all(6),
//             color: Colors.transparent,
//             child: GestureDetector(
//               onTap: () => onAddMember(),
//               child: Row(children: <Widget>[
//                 Container(
//                   width: 50,
//                   child: UserAvatar(initial: "+"),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(child: Text("Add Members")),
//               ]),
//             ),
//           );
//         }
//         ChatMember member = members[i];
//
//         if (members.length <= 2 && member.puid == SessionData.me?.puid)
//           return _ResultItem(
//             member: member,
//             icon: Container(
//               width: 50,
//               child: UserAvatar.fromChatMember(member),
//             ),
//           );
//
//         return Slidable(
//           key: Key(member.puid ?? ""),
//           controller: slidableController,
//           actionPane: SlidableDrawerActionPane(),
//           actionExtentRatio: 0.25,
//           child: Container(
//             color: Colors.white,
//             child: _ResultItem(
//               member: member,
//               icon: Container(
//                 width: 50,
//                 child: UserAvatar.fromChatMember(member),
//               ),
//             ),
//           ),
//           dismissal: SlidableDismissal(
//             child: SlidableDrawerDismissal(),
//             onDismissed: (actionType) => this.onRemoveMember(i, member),
//           ),
//           secondaryActions: <Widget>[
//             IconSlideAction(
//               caption: 'Delete',
//               color: Colors.red,
//               icon: Icons.delete,
//               onTap: () => this.onRemoveMember(i, member),
//             ),
//           ],
//         );
//       },
//       separatorBuilder: (_, __) => Container(
//         width: double.infinity,
//         height: 1,
//         color: Styles.colorDivider,
//       ),
//     );
//
//     final formDecoration = InputDecoration(
//       isDense: true,
//       border: InputBorder.none,
//       contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
//     );
//
//     return KeyboardKiller(
//       child: Scaffold(
//         body: WillPopScope(
//           onWillPop: () async {
//             Navigator.pop(context, this.members);
//             return true;
//           },
//           child: SafeArea(
//               child: Column(
//             children: [
//               SizedBox(height: 16),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text("Group name:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18,
//                         ),
//                         textAlign: TextAlign.left),
//                     SizedBox(height: 8),
//                     TextFormField(
//                       focusNode: focusNode,
//                       controller: groupNameCtrl,
//                       textAlign: TextAlign.left,
//                       decoration: formDecoration.copyWith(
//                         hintText: "Group name",
//                         suffix: isEditGroupName
//                             ? GestureDetector(
//                                 onTap: () => this.onChangeGroupName(),
//                                 child: Icon(
//                                   Icons.save,
//                                   color: Styles.colorPrimary,
//                                   size: 20,
//                                 ))
//                             : GestureDetector(
//                                 onTap: () => this.onEditGroupName(),
//                                 child: Icon(
//                                   Icons.edit,
//                                   color: Styles.grey,
//                                   size: 20,
//                                 ),
//                               ),
//                       ),
//                       readOnly: !isEditGroupName,
//                       textInputAction: TextInputAction.done,
//                       onEditingComplete: () =>
//                           FocusScope.of(context).nextFocus(),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               Expanded(child: list),
//             ],
//           )),
//         ),
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Text("Chat manager"),
//         ),
//       ),
//     );
//   }
// }
//
// class _ResultItem extends StatelessWidget {
//   final ChatMember member;
//   final Widget icon;
//   final Color? backgroundColor;
//
//   _ResultItem({
//     required this.member,
//     required this.icon,
//     this.backgroundColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final centerInfo = Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         ChatDisplayName(
//           kunm: this.member.kunm ?? "",
//           lnm: this.member.lastName ?? "",
//           mnm: this.member.middleName ?? "",
//           fnm: this.member.firstName ?? "",
//         ),
//         // SizedBox(height: 4),
//         // IconLabel(
//         //   asset: Assets.IMG_PHONE,
//         //   text: Util.maskedFone(Util.prettyFone(
//         //     foneCode: "",
//         //     number: this.member.phone ?? "",
//         //   )),
//         // ),
//       ],
//     );
//     return Container(
//       padding: EdgeInsets.all(6),
//       color: Colors.transparent,
//       child: Row(children: <Widget>[
//         this.icon,
//         SizedBox(width: 16),
//         Expanded(child: centerInfo),
//       ]),
//     );
//   }
// }
