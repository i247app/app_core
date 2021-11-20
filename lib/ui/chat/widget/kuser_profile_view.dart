import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/klink_helper.dart';
import 'package:app_core/ui/chat/kchat_screen.dart';
import 'package:app_core/ui/chat/widget/kgig_user_label.dart';
import 'package:app_core/ui/widget/kdetail_view.dart';
import 'package:app_core/ui/widget/kimage_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KUserProfileView extends StatefulWidget {
  final KUser? user;
  final String? puid;

  KUserProfileView.fromUser(this.user) : puid = null;

  KUserProfileView.fromPUID(this.puid) : user = null;

  @override
  State<StatefulWidget> createState() => _KUserProfileViewState();
}

class _KUserProfileViewState extends State<KUserProfileView> {
  final Completer<KUser> completer = Completer<KUser>();

  @override
  void initState() {
    super.initState();
    setupUser();
  }

  void setupUser() async {
    KUser? val;
    try {
      val = widget.user ??
          (await KServerHandler.getUsers(puid: widget.puid)
              .then((r) => r.users?.first));
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
          return _ConcreteKUserProfileView(snapshot.data as KUser);
        } else {
          return Scaffold(body: Container());
        }
      },
    );
  }
}

class _ConcreteKUserProfileView extends StatelessWidget {
  final KUser user;

  const _ConcreteKUserProfileView(this.user);

  @override
  Widget build(BuildContext context) {
    final header = GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => KImageViewer.network(user.avatarURL))),
      behavior: HitTestBehavior.opaque,
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        child: Container(
          height: 60,
          child: KGigUserLabel(this.user),
        ),
      ),
    );

    final detailItems = [
      KDetailItem(
        label: "ID",
        value: this.user.puid,
      ),
      KDetailItem(
        label: "Full Name",
        value: this.user.fullName,
      ),
      KDetailItem(
        label: "Username",
        value: this.user.kunm == null ? null : "@${this.user.kunm}",
      ),
      GestureDetector(
        onTap: () => KLinkHelper.openEmail(this.user.email ?? ""),
        child: KDetailItem(
          label: "Email",
          value: this.user.email,
        ),
      ),
      GestureDetector(
        onTap: () => KLinkHelper.openPhone(this.user.phone ?? ""),
        child: KDetailItem(
          label: "Phone Number",
          value: this.user.phone == null ? null : this.user.prettyFone,
        ),
      ),
      KDetailItem(
        label: "School Name",
        value: this.user.schoolName,
      ),
      KDetailItem(
        label: "Grade Level",
        value: this.user.gradeLevel,
      ),
      KDetailItem(
        label: "Note",
        value: this.user.knote,
      ),
      // KDetailItem(
      //   label: "Start date",
      //   value: this.user.startDate == null
      //       ? null
      //       : KUtil.prettyDate(this.user.startDate, showTime: true),
      // ),
    ];

    final actions = [
      IconButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>
                KChatScreen(members: [KChatMember.fromUser(this.user)]))),
        icon: Icon(Icons.chat, color: Colors.white),
      ),
    ];

    final body = KDetailView(
      header: header,
      actions: actions,
      detailItems: detailItems,
    );
    return body;
  }
}
