import 'dart:async';

import 'package:app_core/helper/kserver_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/ui/chat/widget/kgig_user_label.dart';

class UserProfileView extends StatefulWidget {
  static const double ICON_SIZE = 80;

  final KUser? user;
  final String? puid;
  final Function({String? puid})? getUsers;

  const UserProfileView({this.user, this.puid, this.getUsers});

  @override
  State<StatefulWidget> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final Completer<KUser> completer = Completer();

  @override
  void initState() {
    super.initState();
    setupUser();
  }

  Future<KUser?> setupUser() async {
    if (widget.user != null) {
      return widget.user;
    } else if (widget.puid != null) {
      final response = await KServerHandler.getUsers(puid: widget.puid!);
      return response.user;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setupUser(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return _ConcreteUserProfileView(snapshot.data as KUser);
        } else {
          return Scaffold(body: Container());
        }
      },
    );
  }
}

class _ConcreteUserProfileView extends StatelessWidget {
  final KUser user;

  const _ConcreteUserProfileView(this.user);

  @override
  Widget build(BuildContext context) {
    final userInfo = IgnorePointer(
      child: Container(
        height: 80,
        child: KGigUserLabel(this.user),
      ),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [Center(child: userInfo)],
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(this.user.fullName ?? ""),
      ),
      body: body,
    );
  }
}
