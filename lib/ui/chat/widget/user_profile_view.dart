import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/user.dart';
import 'package:app_core/ui/chat/widget/gig_user_label.dart';

class AppCoreUserProfileView extends StatefulWidget {
  static const double ICON_SIZE = 80;

  final KUser? user;
  final String? puid;
  final Function({ String? puid })? getUsers;

  const AppCoreUserProfileView({this.user, this.puid, this.getUsers});

  @override
  State<StatefulWidget> createState() => _AppCoreUserProfileViewState();
}

class _AppCoreUserProfileViewState extends State<AppCoreUserProfileView> {
  final Completer<KUser> completer = Completer();

  @override
  void initState() {
    super.initState();
    setupUser();
  }

  void setupUser() async {
    KUser? val;
    try {
      if (this.widget.getUsers == null) return;

      val = widget.user ??
          (await this.widget.getUsers!(puid: widget.puid)).users?.first;
    } catch (e) {
      val = null;
    }
    this.completer.complete(val);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.completer.future,
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
