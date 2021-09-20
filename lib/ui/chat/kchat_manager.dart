import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/ui/chat/kchat_contact_listing.dart';
import 'package:app_core/ui/widget/kchat_display_name.dart';
import 'package:app_core/ui/widget/kkeyboard_killer.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class KChatManager extends StatefulWidget {
  final String chatId;
  final String? chatTitle;
  final String? refID;
  final String? refApp;
  final List<KChatMember> members;

  const KChatManager({
    Key? key,
    required this.chatId,
    required this.members,
    this.refID,
    this.refApp,
    this.chatTitle,
  }) : super(key: key);

  @override
  _KChatManagerState createState() => _KChatManagerState();
}

class _KChatManagerState extends State<KChatManager> {
  List<KChatMember> members = [];
  final SlidableController slidableController = SlidableController();
  final FocusNode focusNode = FocusNode();
  final groupNameCtrl = TextEditingController();

  bool isEditGroupName = false;

  @override
  void initState() {
    super.initState();
    members.addAll(widget.members);

    if (KStringHelper.isExist(this.widget.chatTitle)) {
      this.groupNameCtrl.text = this.widget.chatTitle!;
    }
  }

  void onRemoveMember(int memberIndex, KChatMember member) async {
    final response = await KServerHandler.removeChatMembers(
      this.widget.chatId,
      KStringHelper.isExist(member.puid) ? [member.puid!] : [],
      this.widget.refApp,
      this.widget.refID,
    );

    if (response.isSuccess) {
      // Then show a snackbar.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${member.firstName} has been removed from chat')));
      setState(() {
        members.removeAt(memberIndex);
      });
    }
  }

  Future<List<KUser>> searchUsers(String? searchText) async {
    if ((searchText ?? "").isEmpty) {
      return Future.value([]);
    }

    final response = await KServerHandler.searchUsers(searchText!);
    if (response.kstatus == 100) return response.users ?? [];

    return [];
  }

  void onAddMember() async {
    List<KUser>? result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => KChatContactListing(this.searchUsers)));

    if (result == null || result.length == 0) return;

    final response = await KServerHandler.addChatMembers(
      chatID: this.widget.chatId,
      refPUIDs: result.map((u) => u.puid!).toList(),
      refApp: this.widget.refApp,
      refID: this.widget.refID,
    );

    if (response.isSuccess) {
      print("MEMBERS BEFORE - ${this.members.length}");
      setState(() => this.members.addAll(response.members!));
      print("MEMBERS AFTER - ${this.members.length}");
    }
  }

  void onEditGroupName() {
    this.setState(() {
      this.isEditGroupName = true;
    });
  }

  void onChangeGroupName() {
    this.setState(() {
      this.isEditGroupName = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = ListView.separated(
      padding: EdgeInsets.all(4),
      itemCount: members.length + 1,
      itemBuilder: (_, i) {
        if (i == members.length) {
          return Container(
            padding: EdgeInsets.all(6),
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () => onAddMember(),
              child: Row(children: <Widget>[
                Container(
                  width: 50,
                  child: KUserAvatar(initial: "+"),
                ),
                SizedBox(width: 16),
                Expanded(child: Text("Add Members")),
              ]),
            ),
          );
        }
        KChatMember member = members[i];

        if (members.length <= 2 && member.puid == KSessionData.me?.puid)
          return _ResultItem(
            member: member,
            icon: Container(
              width: 50,
              child: KUserAvatar.fromChatMember(member),
            ),
          );

        return Slidable(
          key: Key(member.puid ?? ""),
          controller: slidableController,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: _ResultItem(
              member: member,
              icon: Container(
                width: 50,
                child: KUserAvatar.fromChatMember(member),
              ),
            ),
          ),
          dismissal: SlidableDismissal(
            child: SlidableDrawerDismissal(),
            onDismissed: (actionType) => this.onRemoveMember(i, member),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => this.onRemoveMember(i, member),
            ),
          ],
        );
      },
      separatorBuilder: (_, __) => Container(
        width: double.infinity,
        height: 1,
        color: Theme.of(context).dividerTheme.color,
      ),
    );

    return KeyboardKiller(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, this.members);
            return true;
          },
          child: SafeArea(
              child: Column(
            children: [
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Group name:",
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.left),
                    SizedBox(height: 8),
                    TextFormField(
                      focusNode: focusNode,
                      controller: groupNameCtrl,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: "Group name",
                        suffix: isEditGroupName
                            ? GestureDetector(
                                onTap: () => this.onChangeGroupName(),
                                child: Icon(
                                  Icons.save,
                                  size: 20,
                                ))
                            : GestureDetector(
                                onTap: () => this.onEditGroupName(),
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                              ),
                      ),
                      readOnly: !isEditGroupName,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(child: list),
            ],
          )),
        ),
        appBar: AppBar(
          title: Text("Chat manager"),
        ),
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final KChatMember member;
  final Widget icon;
  final Color? backgroundColor;

  _ResultItem({
    required this.member,
    required this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final centerInfo = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ChatDisplayName(
          kunm: this.member.kunm ?? "",
          lnm: this.member.lastName ?? "",
          mnm: this.member.middleName ?? "",
          fnm: this.member.firstName ?? "",
        ),
      ],
    );
    return Container(
      padding: EdgeInsets.all(6),
      color: Colors.transparent,
      child: Row(children: <Widget>[
        this.icon,
        SizedBox(width: 16),
        Expanded(child: centerInfo),
      ]),
    );
  }
}
