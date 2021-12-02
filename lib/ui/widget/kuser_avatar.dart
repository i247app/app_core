import 'package:app_core/header/kassets.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/model/kchat.dart';
import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/model/kuser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KUserAvatar extends StatelessWidget {
  final String? initial;
  final String? imageURL;
  final Image? imagePlaceHolder;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? size;

  Image get placeholderImage =>
      imagePlaceHolder ?? Image.asset(KAssets.IMG_TRANSPARENCY);

  const KUserAvatar({
    this.initial,
    this.imageURL,
    this.imagePlaceHolder,
    this.backgroundColor,
    this.foregroundColor,
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
                fit: BoxFit.cover,
                child: CircleAvatar(
                  backgroundColor:
                      backgroundColor ?? Theme.of(context).colorScheme.primary,
                  foregroundColor: foregroundColor ?? Colors.white,
                  child: Text(
                    KStringHelper.substring(initial!, 0, 2).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: foregroundColor ?? Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
        : FadeInImage.assetNetwork(
            placeholder: KAssets.IMG_TRANSPARENCY,
            image: imageURL!,
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 100),
            imageErrorBuilder: (ctx, exc, stackTrace) => placeholderImage,
          );

    final body = AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size ?? 100),
          border: Border.all(color: Colors.black, width: 0.1),
        ),
        child: ClipOval(child: raw),
      ),
    );

    return Container(height: size, child: body);
  }
}
