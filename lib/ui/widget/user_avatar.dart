import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/session_data.dart';
import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/model/chat.dart';
import 'package:app_core/model/user.dart';
import 'package:app_core/header/styles.dart';

class UserAvatar extends StatelessWidget {
  final String? initial;
  final String? imageURL;

  const UserAvatar({this.initial, this.imageURL});

  factory UserAvatar.fromUser(User? user) => UserAvatar(
        initial: user?.firstInitial,
        imageURL: user?.avatar,
      );

  factory UserAvatar.fromChat(Chat? chat) => UserAvatar(
        initial: chat?.firstInitial,
        imageURL: (chat?.members ?? []).length < 2
            ? null
            : chat?.members
                ?.where((member) => member.puid != SessionData.me?.puid)
                .first
                .avatar,
      );

  factory UserAvatar.me() => UserAvatar.fromUser(SessionData.me);

  @override
  Widget build(BuildContext context) {
    final raw = this.imageURL == null || !StringHelper.isExist(this.imageURL)
        ? this.initial == null
            ? Container()
            : FittedBox(
                fit: BoxFit.contain,
                child: CircleAvatar(
                  backgroundColor: Styles.colorButton,
                  foregroundColor: Styles.black,
                  child: Text(
                    StringHelper.substring(this.initial!, 0, 2).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Styles.normalText.copyWith(
                      fontSize: 24,
                      color: Styles.white,
                    ),
                  ),
                ),
              )
        : FadeInImage.assetNetwork(
            placeholder: "",
            image: this.imageURL!,
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 100),
            imageErrorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Container();
            },
          );

    final body = AspectRatio(
      aspectRatio: 1,
      child: ClipOval(child: raw),
    );

    return body;
  }
}
