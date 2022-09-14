import 'package:app_core/app_core.dart';
import 'package:app_core/header/kassets.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/model/kchat.dart';
import 'package:app_core/model/kchat_member.dart';
import 'package:app_core/model/kuser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class KUserAvatar extends StatelessWidget {
  final String? initial;
  final String? imageURL;
  final Image? imagePlaceHolder;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? size;
  final bool? isCached;
  final Color highlightColor;
  final double highlightSize;
  final IconData? icon;
  final Color? iconColor;
  final bool? showOnlineStatus;
  final bool? isOnline;
  final Function? onFinishLoaded;

  Image get placeholderImage =>
      imagePlaceHolder ?? Image.asset(KAssets.IMG_TRANSPARENCY);

  const KUserAvatar({
    this.initial,
    this.imageURL,
    this.imagePlaceHolder,
    this.backgroundColor,
    this.foregroundColor,
    this.size,
    this.isCached = true,
    this.highlightColor = Colors.black,
    this.highlightSize = 0.1,
    this.icon,
    this.iconColor,
    this.showOnlineStatus,
    this.isOnline,
    this.onFinishLoaded,
  });

  factory KUserAvatar.fromUser(
    KUser? user, {
    Image? imagePlaceHolder,
    double? size,
    bool? isCached,
    Color highlightColor = Colors.black,
    double highlightSize = 0.1,
    IconData? icon,
    Color? iconColor,
    bool? showOnlineStatus,
    bool? isOnline,
    Function? onFinishLoaded,
  }) =>
      KUserAvatar(
        initial: user?.firstInitial,
        imageURL: user?.avatarURL,
        imagePlaceHolder: imagePlaceHolder,
        size: size,
        isCached: isCached,
        icon: icon,
        iconColor: iconColor,
        showOnlineStatus: showOnlineStatus,
        isOnline: isOnline,
        highlightSize: highlightSize,
        highlightColor: highlightColor,
        onFinishLoaded: onFinishLoaded,
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

  Widget buildFadeInImage() {
    try {
      Widget widget = imageURL == null
          ? placeholderImage
          : FadeInImage.assetNetwork(
              placeholder: KAssets.IMG_TRANSPARENCY,
              image: imageURL ?? "",
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 100),
              imageErrorBuilder: (ctx, exc, stackTrace) => placeholderImage,
            );
      return widget;
    } catch (e) {
      print("KUserAvatar.buildFadeInImage: $e");
      return placeholderImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    var raw = null;
    if ((imageURL ?? "").isEmpty && (initial ?? "").isEmpty) {
      raw = placeholderImage;
    }
    if ((imageURL ?? "").isEmpty && !(initial ?? "").isEmpty) {
      raw = FittedBox(
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
      );
    }
    if (!(imageURL ?? "").isEmpty) {
      raw = isCached == true
          ? CachedNetworkImage(
              imageUrl: imageURL ?? "",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => placeholderImage,
              errorWidget: (context, url, error) => placeholderImage,
            )
          : buildFadeInImage();
    }

    final body = AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size ?? 100),
        ),
        child: ClipOval(child: raw ?? placeholderImage),
      ),
    );
    final badgeSize = (size ?? 100) * 0.4;
    return Container(
      height: size,
      child: Stack(children: [
        body,
        if (this.showOnlineStatus ?? false)
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              child: Icon(
                Icons.fiber_manual_record,
                size: badgeSize,
                color: (this.isOnline ?? false)
                    ? KStyles.green
                    : Colors.grey.shade400,
              ),
            ),
          ),
        if (this.icon != null && this.iconColor != null)
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              // padding: EdgeInsets.only(
              //     top: (size ?? 100) * 0.01, left: (size ?? 100) * 0.01),
              decoration: BoxDecoration(
                color: this.highlightColor,
                borderRadius: BorderRadius.circular(
                  badgeSize / 2,
                ),
              ),
              width: badgeSize,
              height: badgeSize,
              child: Icon(this.icon!, size: badgeSize, color: this.iconColor!),
            ),
          ),
      ]),
    );
  }
}
