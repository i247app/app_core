import 'dart:async';

import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/ui/chat/widget/kuser_view.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:flutter/material.dart';

enum KContactType { reward, transfer, share, other }

class KChooseContact extends StatefulWidget {
  final bool multiselect;
  final KContactType contactType;

  const KChooseContact(
      {this.multiselect = false, this.contactType = KContactType.other});

  @override
  _KChooseContactState createState() => _KChooseContactState();
}

class _KChooseContactState extends State<KChooseContact> {
  static const Duration SEARCH_DELAY = Duration(milliseconds: 250);

  final focusNode = FocusNode();
  final searchFieldCtrl = TextEditingController();

  List<KUser>? userLists;
  String? currentSearchText;
  Timer? timer;

  bool isSearching = false;
  int searchReqID = -1;
  List<KUser> selectedUsers = [];
  List<KUser>? recentUsers;

  @override
  void initState() {
    super.initState();
    // If contactType is transfer, then we need list recent users from kserver
    if (widget.contactType == KContactType.transfer) {
      KServerHandler.recentsUsers().then((response) {
        if (response.isSuccess) {
          setState(() {
            recentUsers = response.users;
          });
        }
      });
    }
  }

  void onSearchChanged(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        userLists = null;
      });
    }
    setState(() => currentSearchText = searchText);

    timer?.cancel();
    timer = Timer(SEARCH_DELAY, () => searchUsers(searchText));
  }

  void searchUsers(String searchText) async {
    final myReqID = ++searchReqID;

    List<KUser>? searchedUsers = [];
    if (searchText.isEmpty) {
      searchedUsers = null;
    } else {
      setState(() => isSearching = true);
      final response = await KServerHandler.searchUsers(searchText);
      setState(() => isSearching = false);

      if (response.kstatus == 100) {
        searchedUsers = response.users;
      } else if (response.kstatus == 202) {
        searchedUsers = [];
      }
    }

    if (myReqID == searchReqID) {
      setState(() => userLists = searchedUsers);
    }
  }

  void onSearchResultClick(KUser user) {
    if (KStringHelper.isEmpty(user.puid)) return;

    if (widget.multiselect) {
      if (selectedUsers
          .where((su) => su.puid == user.puid)
          .isEmpty) {
        setState(() {
          selectedUsers.add(user);
          searchFieldCtrl.clear();
        });
      }
    } else {
      Navigator.of(context).pop(user);
    }
  }

  void onComplete() => Navigator.of(context).pop(selectedUsers);

  @override
  Widget build(BuildContext context) {
    final searchInput = _SearchField(
      searchFieldCtrl: searchFieldCtrl,
      onChanged: onSearchChanged,
      readOnly: false,
      focusNode: focusNode,
      onTap: () {},
      onSelectedUserTap: (u) =>
          setState(() => selectedUsers.removeWhere((su) => su.puid == u.puid)),
      selectedUsers: selectedUsers,
    );

    final userListing;
    if (userLists == null && recentUsers == null) {
      userListing = Container();
    } else if (userLists != null && userLists!.isEmpty) {
      userListing = Center(
        child: Text(
          KPhrases.noContactFound,
          textAlign: TextAlign.center,
          style: Theme
              .of(context)
              .textTheme
              .bodyText1,
        ),
      );
    } else {
      userListing = ListView.builder(
        padding: EdgeInsets.all(4),
        itemCount: (userLists ?? recentUsers ?? []).length,
        itemBuilder: (_, i) {
          final user = (userLists ?? recentUsers ?? [])[i];
          return _ResultItem(
            user: user,
            onClick: onSearchResultClick,
            icon: Container(
              width: 48,
              child: KUserAvatar.fromUser(user),
            ),
          );
        },
      );
    }

    final doneButton = TextButton(
      onPressed: selectedUsers.length > 0 ? onComplete : null,
      child: Text("OK"),
    );

    final topBar = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CloseButton(),
        Spacer(),
        doneButton,
      ],
    );

    final body = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          topBar,
          SizedBox(height: 8),
          searchInput,
          SizedBox(height: 10),
          Expanded(child: userListing),
        ],
      ),
    );

    return KeyboardKiller(child: Scaffold(body: body));
  }
}

class _SearchField extends StatelessWidget {
  final Function(String) onChanged;
  final bool readOnly;
  final FocusNode focusNode;
  final TextEditingController searchFieldCtrl;
  final VoidCallback onTap;
  final Function(KUser) onSelectedUserTap;
  final List<KUser> selectedUsers;

  _SearchField({
    required this.onChanged,
    required this.readOnly,
    required this.focusNode,
    required this.searchFieldCtrl,
    required this.onTap,
    required this.onSelectedUserTap,
    required this.selectedUsers,
  });

  @override
  Widget build(BuildContext context) {
    final searchField = Theme(
      data: ThemeData(
        inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
      ),
      child: TextField(
        maxLength: 50,
        keyboardType: TextInputType.text,
        focusNode: focusNode,
        textAlign: TextAlign.left,
        controller: searchFieldCtrl,
        onChanged: onChanged,
        autofocus: true,
        showCursor: true,
        onTap: onTap,
        readOnly: readOnly,
        style: Theme
            .of(context)
            .textTheme
            .headline6,
        decoration: InputDecoration(
          hintText: "name or phone",
          hintStyle: TextStyle(color: Theme
              .of(context)
              .primaryColorLight),
          counterText: "",
          // contentPadding: EdgeInsets.symmetric(vertical: 2),
          border: InputBorder.none,
        ),
      ),
    );

    final selectedUserChips = this
        .selectedUsers
        .map((su) =>
        GestureDetector(
          onTap: () => onSelectedUserTap.call(su),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(0.1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  su.fullName ?? su.contactName,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1,
                ),
                SizedBox(width: 6),
                Icon(Icons.close, size: 20),
              ],
            ),
          ),
        ))
        .toList();

    final searchRow = Row(
      children: [
        Icon(
          Icons.search,
          size: 24,
        ),
        SizedBox(width: 16),
        Expanded(child: searchField),
      ],
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(color: Colors.black12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: searchRow,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(spacing: 4, runSpacing: 4, children: selectedUserChips),
          ),
          Divider(color: Colors.black12),
        ],
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final KUser user;
  final Widget icon;
  final Function(KUser user) onClick;
  final Color? backgroundColor;

  _ResultItem({
    required this.user,
    required this.icon,
    required this.onClick,
    this.backgroundColor,
  });

  void onMoreInfoClick(ctx) =>
      Navigator.of(ctx)
          .push(MaterialPageRoute(builder: (_) => KUserView.fromUser(user)));

  @override
  Widget build(BuildContext context) {
    // final phoneView = KIconLabel(
    //   asset: KAssets.IMG_PHONE,
    //   text: KUtil.maskedFone(
    //     KUtil.prettyFone(
    //       foneCode: user.phoneCode ?? "",
    //       number: user.phone ?? "",
    //     ),
    //   ),
    // );

    final contactHandle = Text(
      user.kunm == null ? user.prettyFone : "@${user.kunm}",
      style: Theme
          .of(context)
          .textTheme
          .subtitle1
          ?.copyWith(
        color: Theme
            .of(context)
            .primaryColorLight,
      ),
    );

    final idText = Text(
      "ID: ${user.puid}",
      style: Theme
          .of(context)
          .textTheme
          .subtitle1
          ?.copyWith(
        color: Theme
            .of(context)
            .primaryColorLight,
      ),
    );

    final contactRow =
    Row(children: [contactHandle, SizedBox(width: 8), idText]);

    final info = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          user.fullName ?? "",
          style: Theme
              .of(context)
              .textTheme
              .subtitle1,
        ),
        SizedBox(height: 6),
        contactRow,
      ],
    );

    final moreInfoButton = IconButton(
      onPressed: () => onMoreInfoClick(context),
      iconSize: 24,
      icon: Icon(
        Icons.info,
        color: Theme
            .of(context)
            .primaryColorLight,
      ),
    );

    return InkWell(
      onTap: () => onClick.call(user),
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            icon,
            SizedBox(width: 16),
            Expanded(child: info),
            moreInfoButton,
          ],
        ),
      ),
    );
  }
}
