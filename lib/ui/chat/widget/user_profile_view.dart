// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:app_core/model/user.dart';
// import 'package:app_core/network/server_handler.dart';
// import 'package:app_core/ui/chat/widget/gig_user_label.dart';
//
// class UserProfileView extends StatefulWidget {
//   static const double ICON_SIZE = 80;
//
//   final User? user;
//   final String? puid;
//
//   const UserProfileView({this.user, this.puid});
//
//   @override
//   State<StatefulWidget> createState() => _UserProfileViewState();
// }
//
// class _UserProfileViewState extends State<UserProfileView> {
//   final Completer<User> completer = Completer();
//
//   @override
//   void initState() {
//     super.initState();
//     setupUser();
//   }
//
//   void setupUser() async {
//     User? val;
//     try {
//       val = widget.user ??
//           (await ServerHandler.getUsers(puid: widget.puid)
//               .then((r) => r.users?.first));
//     } catch (e) {
//       val = null;
//     }
//     this.completer.complete(val);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: this.completer.future,
//       builder: (ctx, snapshot) {
//         if (snapshot.hasData) {
//           return _ConcreteUserProfileView(snapshot.data as User);
//         } else {
//           return Scaffold(body: Container());
//         }
//       },
//     );
//   }
// }
//
// class _ConcreteUserProfileView extends StatelessWidget {
//   final User user;
//
//   const _ConcreteUserProfileView(this.user);
//
//   @override
//   Widget build(BuildContext context) {
//     final userInfo = IgnorePointer(
//       child: Container(
//         height: 80,
//         child: GigUserLabel(this.user),
//       ),
//     );
//
//     final body = Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [Center(child: userInfo)],
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(this.user.fullName ?? ""),
//       ),
//       body: body,
//     );
//   }
// }
