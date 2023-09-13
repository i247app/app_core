import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/ui/widget/kcontact_name_view.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/ui/widget/kicon_label.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';

class KChatContactListing extends StatefulWidget {
  final Function(String? searchText) searchUsers;

  KChatContactListing(this.searchUsers);

  @override
  _KChatContactListingState createState() => _KChatContactListingState();
}

class _KChatContactListingState extends State<KChatContactListing> {
  static const Duration SEARCH_DELAY = Duration(milliseconds: 250);

  final TextEditingController searchCtrl = TextEditingController();

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
      final response = await KServerHandler.searchUsers(searchText);
      setState(() => this.isSearching = false);

      searchedUsers = response.users;
    }

    if (myReqID == searchReqID) {
      setState(() => this.userLists = searchedUsers);
    }
  }

  void onSearchChanged(String searchText) {
    setState(() => this.currentSearchText = searchText);

    this.timer?.cancel();
    this.timer = Timer(SEARCH_DELAY, () => searchUsers(searchText));
  }

  void onSearchResultClick(KUser user) {
    if (KStringHelper.isEmpty(user.puid)) {
      if (KSessionData.isSomeKindOfAdmin || KUtil.isDebug) {
        KToastHelper.error("selected user.puid empty");
      }
      return;
    } else if (selectedUsers.where((su) => su.puid == user.puid).isNotEmpty) {
      if (KSessionData.isSomeKindOfAdmin || KUtil.isDebug) {
        KToastHelper.error("user already selected");
      }
      return;
    }

    setState(() {
      selectedUsers.add(user);
      searchCtrl.clear();
    });
  }

  void onComplete() async {
    if (KSessionData.isSomeKindOfAdmin || KUtil.isDebug) {
      KToastHelper.error("selectedUsers.length: ${selectedUsers.length}");
      await Future.delayed(Duration(milliseconds: 250));
    }
    Navigator.of(context).pop(selectedUsers);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final doneButton = TextButton(
      onPressed: onComplete,
      child: Text("OK"),
    );

    final topBar = Row(
      children: [
        BackButton(),
        Text("Choose Users", style: theme.textTheme.titleMedium),
        Spacer(),
        doneButton,
      ],
    );

    final searchInput = _SearchField(
      searchFieldController: this.searchCtrl,
      onChanged: onSearchChanged,
      readOnly: false,
      focusNode: this.focusNode,
      onTap: () {},
      onSelectedUserTap: (u) => setState(
          () => this.selectedUsers.removeWhere((su) => su.puid == u.puid)),
      selectedUsers: this.selectedUsers,
    );

    final userListing;
    if (userLists == null) {
      userListing = Container();
    } else if (userLists!.isEmpty) {
      userListing = Center(
        child: Text(
          "Nothing found!",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
      );
    } else {
      userListing = ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 6),
        itemCount: (userLists ?? []).length,
        itemBuilder: (_, i) {
          final user = (userLists ?? [])[i];
          if (user.puid == KSessionData.me?.puid) {
            return Container();
          }

          return _ResultItem(
            user: user,
            onClick: onSearchResultClick,
            icon: Container(
              width: 40,
              child: KUserAvatar.fromUser(user),
            ),
          );
        },
        separatorBuilder: (_, __) => Container(
          height: 1,
          color: Theme.of(context).primaryColor.withOpacity(0.08),
        ),
      );
    }

    final body = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          topBar,
          SizedBox(height: 8),
          searchInput,
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
    final searchField = Theme(
      data: ThemeData(
          inputDecorationTheme:
              InputDecorationTheme(border: OutlineInputBorder())),
      child: TextField(
        maxLength: 12,
        keyboardType: TextInputType.text,
        focusNode: this.focusNode,
        textAlign: TextAlign.left,
        controller: this.searchFieldController,
        onChanged: this.onChanged,
        autofocus: true,
        showCursor: true,
        onTap: this.onTap,
        readOnly: this.readOnly,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: "Type a name or phone number",
          counterText: "",
        ),
      ),
    );

    final selectedUserChips = this
        .selectedUsers
        .map((su) => GestureDetector(
              onTap: () => onSelectedUserTap.call(su),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      su.fullName ?? su.contactName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.close, size: 20),
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
          SizedBox(height: 2),
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
      children: [
        KContactNameView.fromUser(user),
        SizedBox(height: 4),
        KIconLabel(
          icon: Icons.phone,
          text: KUtil.maskedFone(KUtil.prettyFone(
            foneCode: user.phoneCode ?? "",
            number: user.phone ?? "",
          )),
        ),
      ],
    );

    return InkWell(
      onTap: () => onClick.call(user),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        color: Colors.transparent,
        child: Row(
          children: [
            icon,
            SizedBox(width: 10),
            Expanded(child: centerInfo),
          ],
        ),
      ),
    );
  }
}
