import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';

class OldContactSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OldContactSearchState();
}

class _OldContactSearchState extends State<OldContactSearch> {
  List<KUser>? users;

  List<KUser> get userList =>
      (this.users ?? []).where((u) => u.puid != KSessionData.me?.puid).toList();

  void loadUsers(String searchText) async {
    final response = await KServerHandler.searchUsers(searchText);
    setState(() => this.users = response.users);
  }

  void onSearchChanged(String searchText) {
    if (KStringHelper.isExist(searchText))
      loadUsers(searchText);
    else
      setState(() => this.users = []);
  }

  void onUserClick(KUser user) => Navigator.of(context).pop(user.puid);

  OutlineInputBorder buildBorder(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: color));

  @override
  Widget build(BuildContext context) {
    final searchField = Container(
        padding: EdgeInsets.all(8),
        child: TextField(
          maxLength: 12,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          onChanged: onSearchChanged,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Name / Phone Number",
            counterText: "",
          ),
        ));

    final userList = ListView.builder(
      itemCount: this.userList.length,
      itemBuilder: (_, i) =>
          _ContactItem(this.userList[i], onClick: onUserClick),
    );

    final body = KeyboardKiller(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          searchField,
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            color: Colors.black,
            height: 1,
          ),
          Expanded(child: userList),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Choose a User")),
      body: SafeArea(child: body),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final KUser user;
  final Function(KUser) onClick;

  bool get isPhone => user.firstName == null;

  String get iconLetter => (isPhone ? "#" : (user.firstName ?? user.kunm ?? ""))
      .substring(0, 1)
      .toUpperCase();

  String get title => (isPhone ? user.prettyFone : user.kunm) ?? "";

  // String get detail => isPhone ? "Reward user" : user.fullName;
  String get detail => user.fullName ?? "";

  _ContactItem(this.user, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    final icon = KUserAvatar.fromUser(user);

    return InkWell(
      onTap: () => this.onClick.call(this.user),
      child: Container(
        padding: EdgeInsets.all(6),
        child: Row(
          children: <Widget>[
            icon,
            SizedBox(width: 10),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(isPhone ? title : "@$title", style: TextStyle()),
                  SizedBox(height: 4),
                  Text(
                    this.detail,
                    style: TextStyle(color: KStyles.darkGrey),
                  ),
                ])
          ],
        ),
      ),
    );
  }
}
