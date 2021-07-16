import 'package:flutter/material.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/model/kchat.dart';
import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/header//kstyles.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';

class _ChatIconPosition {
  final double left;
  final double top;

  _ChatIconPosition({required this.left, required this.top});
}

class KChatIcon extends StatelessWidget {
  static const double DEFAULT_SIZE = 60;
  static const double HALF_SIZE = DEFAULT_SIZE / 2;
  static const double CROSS_SIZE = DEFAULT_SIZE * 0.58;

  static final List<_ChatIconPosition> groupTwo = [
    _ChatIconPosition(left: 0, top: 0),
    _ChatIconPosition(
      left: DEFAULT_SIZE - CROSS_SIZE,
      top: DEFAULT_SIZE - CROSS_SIZE,
    )
  ];

  static final List<_ChatIconPosition> groupThree = [
    _ChatIconPosition(left: HALF_SIZE / 2, top: 0),
    _ChatIconPosition(left: 0, top: HALF_SIZE),
    _ChatIconPosition(left: HALF_SIZE, top: HALF_SIZE)
  ];

  static final List<_ChatIconPosition> groupFour = [
    _ChatIconPosition(left: 0, top: 0),
    _ChatIconPosition(left: HALF_SIZE, top: 0),
    _ChatIconPosition(left: 0, top: HALF_SIZE),
    _ChatIconPosition(left: HALF_SIZE, top: HALF_SIZE)
  ];

  final KChat chat;

  KChatIcon({required this.chat});

  List<Widget> buildAvatarGroup(List<KChatMember> members) {
    List<Widget> avatars = [];
    List<_ChatIconPosition> positions = [];
    switch (members.length) {
      case 2:
        positions = groupTwo;
        break;
      case 3:
        positions = groupThree;
        break;
      default:
        positions = groupFour;
        break;
    }
    for (var i = 0; i < members.length && i < 4; i++) {
      _ChatIconPosition position = positions[i];
      KChatMember member = members[i];
      avatars.add(Positioned(
        top: position.top,
        left: position.left,
        child: i == 3 && members.length > 4
            ? Container(
                width: HALF_SIZE,
                height: HALF_SIZE,
                padding: EdgeInsets.all(2),
                child: Icon(
                  Icons.group_add_outlined,
                  color: KStyles.colorPrimary,
                ),
              )
            : ClipOval(
                child: Container(
                  padding: EdgeInsets.all(1),
                  width: members.length == 2 ? CROSS_SIZE : HALF_SIZE,
                  height: members.length == 2 ? CROSS_SIZE : HALF_SIZE,
                  child: KUserAvatar(
                    initial: member.firstInitial,
                    imageURL: member.avatar,
                  ),
                ),
              ),
      ));
    }
    return avatars;
  }

  @override
  Widget build(BuildContext context) {
    bool multiAvatar = this.chat.appCoreMembers!.length > 2;

    return multiAvatar
        ? SizedBox(
            height: DEFAULT_SIZE,
            width: DEFAULT_SIZE,
            child: Stack(
              children: buildAvatarGroup(this
                  .chat
                  .appCoreMembers!
                  .where((member) => member.puid != KSessionData.me?.puid)
                  .toList()),
            ),
          )
        : ClipOval(
            child: Container(
              width: DEFAULT_SIZE,
              height: DEFAULT_SIZE,
              child: KUserAvatar.fromChat(this.chat),
            ),
          );
  }
}
