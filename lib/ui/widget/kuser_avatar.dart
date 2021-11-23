import 'package:app_core/model/kchat.dart';
import 'package:app_core/model/kchat_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/header/kassets.dart';

class KUserAvatar extends StatelessWidget {
  final String? initial;
  final String? imageURL;
  final Image? imagePlaceHolder;
  final double? size;

  Image get placeholderImage =>
      imagePlaceHolder ?? Image.asset(KAssets.IMG_TRANSPARENCY);

  const KUserAvatar({
    this.initial,
    this.imageURL,
    this.imagePlaceHolder,
    this.size,
  });

  factory KUserAvatar.fromUser(
    KUser? user, {
    Image? imagePlaceHolder,
    double? size,
  }) =>
      KUserAvatar(
        initial: user?.firstInitial,
        imageURL: user?.avatarURL,
        imagePlaceHolder: imagePlaceHolder,
        size: size,
      );

  factory KUserAvatar.fromChatMember(KChatMember? member, {double? size}) =>
      KUserAvatar(
        initial: member?.firstInitial,
        imageURL: member?.avatar,
        size: size,
      );

  factory KUserAvatar.fromChat(KChat? chat, {double? size}) => KUserAvatar(
        initial: chat?.chatName,
        size: size,
        imageURL: (chat?.kMembers ?? []).length < 2
            ? null
            : chat?.kMembers
                ?.where((member) => member.puid != KSessionData.me?.puid)
                .first
                .avatar,
      );

  factory KUserAvatar.me({Image? imagePlaceHolder}) =>
      KUserAvatar.fromUser(KSessionData.me, imagePlaceHolder: imagePlaceHolder);

  @override
  Widget build(BuildContext context) {
    final raw = (imageURL ?? "").isEmpty
        ? (initial ?? "").isEmpty
            ? placeholderImage
            : FittedBox(
                fit: BoxFit.contain,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  child: Text(
                    KStringHelper.substring(initial!, 0, 2).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.white),
                  ),
                ),
              )
        : FadeInImage.assetNetwork(
            placeholder: KAssets.IMG_TRANSPARENCY,
            image: imageURL!,
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 100),
            imageErrorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return placeholderImage;
            },
          );

    final body = AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: size,
        height: size,
        child: Center(child: ClipOval(child: raw)),
      ),
    );

    return body;
  }
}
