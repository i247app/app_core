import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kapp_nav_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/klink_helper.dart';
import 'package:app_core/ui/chat/widget/kgig_user_label.dart';
import 'package:app_core/ui/widget/kdetail_view.dart';
import 'package:app_core/ui/widget/kimage_viewer.dart';
import 'package:flutter/material.dart';

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
    completer.complete(val);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: completer.future,
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
      onTap: user.avatarURL == null
          ? null
          : () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => KImageViewer.network(user.avatarURL))),
      behavior: HitTestBehavior.opaque,
      child: IgnorePointer(
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Container(
            height: 40,
            child: KGigUserLabel(user),
          ),
        ),
      ),
    );

    final detailItems = [
      KDetailItem(
        label: "ID",
        value: user.puid,
      ),
      KDetailItem(
        label: "Full Name",
        value: user.fullName,
      ),
      KDetailItem(
        label: "Username",
        value: user.kunm == null ? null : "@${user.kunm}",
      ),
      GestureDetector(
        onTap: () => KLinkHelper.openEmail(user.email ?? ""),
        child: KDetailItem(
          label: "Email",
          value: user.email,
        ),
      ),
      GestureDetector(
        onTap: () => KLinkHelper.openPhone(user.phone ?? ""),
        child: KDetailItem(
          label: "Phone Number",
          value: user.phone == null ? null : user.prettyFone,
        ),
      ),
      KDetailItem(
        label: "School Name",
        value: user.schoolName,
      ),
      KDetailItem(
        label: "Grade Level",
        value: user.gradeLevel,
      ),
      KDetailItem(
        label: "Join Date",
        value: user.joinDate == null ? null : KUtil.prettyDate(user.joinDate),
      ),
      KDetailItem(
        label: "Note",
        value: user.knote,
      ),
      // KDetailItem(
      //   label: "Start date",
      //   value: user.startDate == null
      //       ? null
      //       : KUtil.prettyDate(user.startDate, showTime: true),
      // ),
    ];

    final actions = [
      if (KAppNavHelper.chat == KAppNav.ON)
        IconButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  KChatScreen(members: [KChatMember.fromUser(user)]))),
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
