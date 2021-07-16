import 'package:app_core/model/kchat_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/session_data.dart';
import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/model/kchat.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/header/kstyles.dart';
import 'package:app_core/header/kassets.dart';

class KUserAvatar extends StatelessWidget {
  final String? initial;
  final String? imageURL;
  final Image? imagePlaceHolder;

  const KUserAvatar({this.initial, this.imageURL, this.imagePlaceHolder});

  factory KUserAvatar.fromUser(KUser? user, {Image? imagePlaceHolder}) =>
      KUserAvatar(
        initial: user?.firstInitial,
        imageURL: user?.avatarURL,
        imagePlaceHolder: imagePlaceHolder,
      );

  factory KUserAvatar.fromChatMember(KChatMember? member,
          {Image? imagePlaceHolder}) =>
      KUserAvatar(
        initial: member?.firstInitial,
        imageURL: member?.avatar,
        imagePlaceHolder: imagePlaceHolder,
      );

  factory KUserAvatar.fromChat(KChat? chat, {Image? imagePlaceHolder}) =>
      KUserAvatar(
        initial: chat?.chatName,
        imageURL: (chat?.appCoreMembers ?? []).length < 2
            ? null
            : chat?.appCoreMembers
                ?.where((member) => member.puid != KSessionData.me?.puid)
                .first
                .avatar,
        imagePlaceHolder: imagePlaceHolder,
      );

  factory KUserAvatar.me({Image? imagePlaceHolder}) =>
      KUserAvatar.fromUser(KSessionData.me, imagePlaceHolder: imagePlaceHolder);

  Image get placeholderImage =>
      this.imagePlaceHolder ?? Image.asset(KAssets.IMG_TRANSPARENCY);

  @override
  Widget build(BuildContext context) {
    final raw = this.imageURL == null || !KStringHelper.isExist(this.imageURL)
        ? this.initial == null
            ? placeholderImage
            : FittedBox(
                fit: BoxFit.contain,
                child: CircleAvatar(
                  backgroundColor: KStyles.colorButton,
                  foregroundColor: KStyles.black,
                  child: Text(
                    KStringHelper.substring(this.initial!, 0, 2).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: KStyles.normalText.copyWith(
                      fontSize: 24,
                      color: KStyles.white,
                    ),
                  ),
                ),
              )
        : FadeInImage.assetNetwork(
            placeholder: KAssets.IMG_TRANSPARENCY,
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
