import 'package:app_core/model/chat_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/session_data.dart';
import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/model/chat.dart';
import 'package:app_core/model/user.dart';
import 'package:app_core/header/styles.dart';
import 'package:app_core/header/assets.dart';

class AppCoreUserAvatar extends StatelessWidget {
  final String? initial;
  final String? imageURL;
  final Image? imagePlaceHolder;

  const AppCoreUserAvatar({this.initial, this.imageURL, this.imagePlaceHolder});

  factory AppCoreUserAvatar.fromUser(AppCoreUser? user,
          {Image? imagePlaceHolder}) =>
      AppCoreUserAvatar(
        initial: user?.firstInitial,
        imageURL: user?.avatarURL,
        imagePlaceHolder: imagePlaceHolder,
      );

  factory AppCoreUserAvatar.fromChatMember(AppCoreChatMember? member,
          {Image? imagePlaceHolder}) =>
      AppCoreUserAvatar(
        initial: member?.firstInitial,
        imageURL: member?.avatar,
        imagePlaceHolder: imagePlaceHolder,
      );

  factory AppCoreUserAvatar.fromChat(AppCoreChat? chat,
          {Image? imagePlaceHolder}) =>
      AppCoreUserAvatar(
        initial: chat?.chatName,
        imageURL: (chat?.appCoreMembers ?? []).length < 2
            ? null
            : chat?.appCoreMembers
                ?.where((member) => member.puid != AppCoreSessionData.me?.puid)
                .first
                .avatar,
        imagePlaceHolder: imagePlaceHolder,
      );

  factory AppCoreUserAvatar.me({Image? imagePlaceHolder}) =>
      AppCoreUserAvatar.fromUser(AppCoreSessionData.me,
          imagePlaceHolder: imagePlaceHolder);

  Image get placeholderImage => this.imagePlaceHolder ?? Image.asset(Assets.IMG_TRANSPARENCY);

  @override
  Widget build(BuildContext context) {
    final raw = this.imageURL == null ||
            !AppCoreStringHelper.isExist(this.imageURL)
        ? this.initial == null
            ? placeholderImage
            : FittedBox(
                fit: BoxFit.contain,
                child: CircleAvatar(
                  backgroundColor: Styles.colorButton,
                  foregroundColor: Styles.black,
                  child: Text(
                    AppCoreStringHelper.substring(this.initial!, 0, 2).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Styles.normalText.copyWith(
                      fontSize: 24,
                      color: Styles.white,
                    ),
                  ),
                ),
              )
        : FadeInImage.assetNetwork(
            placeholder: Assets.IMG_TRANSPARENCY,
            image: this.imageURL!,
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 100),
            imageErrorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return placeholderImage;
            },
          );

    final body = AspectRatio(
      aspectRatio: 1,
      child: ClipOval(child: raw),
    );

    return body;
  }
}
