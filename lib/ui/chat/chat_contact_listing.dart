import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/header/kassets.dart';
import 'package:app_core/header/kstyles.dart';
import 'package:app_core/ui/widget/contact_name_view.dart';
import 'package:app_core/ui/widget/icon_label.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/ui/widget/user_avatar.dart';

class KChatContactListing extends StatefulWidget {
  final Function(String? searchText) searchUsers;

  KChatContactListing(this.searchUsers);

  @override
  _KChatContactListingState createState() => _KChatContactListingState();
}

class _KChatContactListingState extends State<KChatContactListing> {
  static const Duration SEARCH_DELAY = Duration(milliseconds: 250);

  final TextEditingController searchFieldController = TextEditingController();

  List<KUser>? userLists;
  String? currentSearchText;
  Timer? timer;

  bool isSearching = false;
  FocusNode focusNode = FocusNode();
  int searchReqID = -1;
  List<KUser> selectedUsers = [];

  void searchUsers(String searchText) async {
    final myReqID = ++this.searchReqID;

    List<KUser>? searchedUsers = [];
    if (searchText.isEmpty) {
      searchedUsers = null;
    } else {
      setState(() => this.isSearching = true);
      final users = await this.widget.searchUsers(searchText);
      setState(() => this.isSearching = false);

      searchedUsers = users;
    }

    if (myReqID == searchReqID) setState(() => this.userLists = searchedUsers);
  }

  void onSearchChanged(String searchText) {
    setState(() => this.currentSearchText = searchText);

    this.timer?.cancel();
    this.timer = Timer(SEARCH_DELAY, () => searchUsers(searchText));
  }

  void onSearchResultClick(KUser user) {
    if (KStringHelper.isEmpty(user.puid)) return;

    if (this.selectedUsers.where((su) => su.puid == user.puid).isEmpty) {
      setState(() {
        this.selectedUsers.add(user);
        this.searchFieldController.clear();
      });
    }
  }

  void onComplete() => Navigator.of(context).pop(this.selectedUsers);

  @override
  Widget build(BuildContext context) {
    final searchInput = _SearchField(
      searchFieldController: this.searchFieldController,
      onChanged: onSearchChanged,
      readOnly: false,
      focusNode: this.focusNode,
      onTap: () {},
      onSelectedUserTap: (u) => setState(
          () => this.selectedUsers.removeWhere((su) => su.puid == u.puid)),
      selectedUsers: this.selectedUsers,
    );

    final userListing;
    if (this.userLists == null)
      userListing = Container();
    else if (this.userLists!.isEmpty)
      userListing = Center(
        child: Text(
          "Nothing found!",
          textAlign: TextAlign.center,
          style: KStyles.normalText,
        ),
      );
    else
      userListing = ListView.separated(
        padding: EdgeInsets.all(4),
        itemCount: (this.userLists ?? []).length,
        itemBuilder: (_, i) {
          KUser user = (this.userLists ?? [])[i];

          if (user.puid == KSessionData.me?.puid) {
            return Container();
          }

          return _ResultItem(
            user: user,
            onClick: onSearchResultClick,
            icon: Container(
              width: 50,
              child: KUserAvatar.fromUser(user),
            ),
          );
        },
        separatorBuilder: (_, __) => Container(
          width: double.infinity,
          height: 1,
          color: KStyles.colorDivider,
        ),
      );

    final doneButton = TextButton(
      onPressed: onComplete,
      child: Text("OK"),
    );

    final body = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              BackButton(),
              Text("Choose Users", style: KStyles.largeText),
              Spacer(),
              doneButton,
            ],
          ),
          SizedBox(height: 8),
          searchInput,
          Divider(height: 1, color: KStyles.colorDivider),
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
  final TextEditingController searchFieldController;
  final VoidCallback onTap;
  final Function(KUser) onSelectedUserTap;
  final List<KUser> selectedUsers;

  _SearchField({
    required this.onChanged,
    required this.readOnly,
    required this.focusNode,
    required this.searchFieldController,
    required this.onTap,
    required this.onSelectedUserTap,
    required this.selectedUsers,
  });

  @override
  Widget build(BuildContext context) {
    final searchField = TextField(
      maxLength: 12,
      maxLines: null,
      focusNode: this.focusNode,
      textAlign: TextAlign.left,
      controller: this.searchFieldController,
      onChanged: this.onChanged,
      autofocus: true,
      showCursor: true,
      onTap: this.onTap,
      readOnly: this.readOnly,
      style: KStyles.normalText,
      decoration: InputDecoration(
        hintText: "Type a name or phone number",
        counterText: "",
        // contentPadding: EdgeInsets.symmetric(vertical: 2),
        border: InputBorder.none,
      ),
    );

    final selectedUserChips = this
        .selectedUsers
        .map((su) => GestureDetector(
              onTap: () => this.onSelectedUserTap.call(su),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: KStyles.colorPrimary.withOpacity(0.1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      su.fullName ?? su.contactName ?? "",
                      style: KStyles.normalText
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.close, size: 20, color: KStyles.grey),
                  ],
                ),
              ),
            ))
        .toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchField,
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: selectedUserChips,
          ),
          SizedBox(height: 6),
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

  @override
  Widget build(BuildContext context) {
    final centerInfo = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        KContactNameView.fromUser(this.user),
        SizedBox(height: 4),
        KIconLabel(
          asset: KAssets.IMG_PHONE,
          text: KUtil.maskedFone(KUtil.prettyFone(
            foneCode: this.user.phoneCode ?? "",
            number: this.user.phone ?? "",
          )),
        ),
      ],
    );

    return InkWell(
      onTap: () => this.onClick.call(this.user),
      child: Container(
        padding: EdgeInsets.all(6),
        color: Colors.transparent,
        child: Row(children: <Widget>[
          this.icon,
          SizedBox(width: 16),
          Expanded(child: centerInfo),
        ]),
      ),
    );
  }
}
