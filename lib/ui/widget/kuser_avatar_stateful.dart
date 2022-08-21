import 'package:app_core/header/kassets.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/model/kchat.dart';
import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/model/kuser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class KUserAvatarStateful extends StatefulWidget {
  final String? initial;
  final String? imageURL;
  final Image? imagePlaceHolder;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? size;
  final bool? isCached;
  final Function? onFinishLoaded;

  Image get placeholderImage =>
      imagePlaceHolder ?? Image.asset(KAssets.IMG_TRANSPARENCY);

  const KUserAvatarStateful({
    this.initial,
    this.imageURL,
    this.imagePlaceHolder,
    this.backgroundColor,
    this.foregroundColor,
    this.size,
    this.isCached = false,
    this.onFinishLoaded,
  });

  factory KUserAvatarStateful.fromUser(
    KUser? user, {
    Image? imagePlaceHolder,
    double? size,
    bool? isCached,
    Function? onFinishLoaded,
  }) =>
      KUserAvatarStateful(
        initial: user?.firstInitial,
        imageURL: user?.avatarURL,
        imagePlaceHolder: imagePlaceHolder,
        size: size,
        isCached: isCached,
        onFinishLoaded: onFinishLoaded,
      );

  factory KUserAvatarStateful.fromChatMember(KChatMember? member,
          {double? size}) =>
      KUserAvatarStateful(
        initial: member?.firstInitial,
        imageURL: member?.avatar,
        size: size,
      );

  factory KUserAvatarStateful.fromChat(KChat? chat, {double? size}) =>
      KUserAvatarStateful(
        initial: chat?.chatName,
        size: size,
        imageURL: (chat?.kMembers ?? []).length < 2
            ? null
            : chat?.kMembers
                ?.where((member) => member.puid != KSessionData.me?.puid)
                .first
                .avatar,
      );

  factory KUserAvatarStateful.me({Image? imagePlaceHolder}) =>
      KUserAvatarStateful.fromUser(KSessionData.me,
          imagePlaceHolder: imagePlaceHolder);

  @override
  _KUserAvatarStatefulState createState() => _KUserAvatarStatefulState();
}

class _KUserAvatarStatefulState extends State<KUserAvatarStateful> {
  @override
  Widget build(BuildContext context) {
    final raw = (widget.imageURL ?? "").isEmpty
        ? (widget.initial ?? "").isEmpty
            ? widget.placeholderImage
            : FittedBox(
                fit: BoxFit.cover,
                child: CircleAvatar(
                  backgroundColor: widget.backgroundColor ??
                      Theme.of(context).colorScheme.primary,
                  foregroundColor: widget.foregroundColor ?? Colors.white,
                  child: Text(
                    KStringHelper.substring(widget.initial!, 0, 2)
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.foregroundColor ?? Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
        : ((widget.isCached ?? false)
            ? CachedNetworkImage(
                imageUrl: widget.imageURL!,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  if ((downloadProgress.progress == null ||
                          downloadProgress.progress == 1) &&
                      widget.onFinishLoaded != null) {
                    widget.onFinishLoaded!();
                  }
                  return CircularProgressIndicator(
                      value: downloadProgress.progress);
                },
              )
            : FadeInImage.assetNetwork(
                placeholder: KAssets.IMG_TRANSPARENCY,
                image: widget.imageURL!,
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 100),
                imageErrorBuilder: (ctx, exc, stackTrace) =>
                    widget.placeholderImage,
              ));

    final body = AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size ?? 100),
          border: Border.all(color: Colors.black, width: 0.1),
        ),
        child: ClipOval(child: raw),
      ),
    );

    return Container(height: widget.size, child: body);
  }
}
