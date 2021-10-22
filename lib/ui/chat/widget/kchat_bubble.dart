import 'dart:convert';

import 'package:app_core/app_core.dart';
import 'package:app_core/header/kassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/kchat_message.dart';
import 'package:app_core/ui/widget/kimage_viewer.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';

class KChatBubble extends StatelessWidget {
  static const Duration SHORT_TIME_CUTOFF = Duration(minutes: 2);
  static const Duration LONG_TIME_CUTOFF = Duration(minutes: 10);
  static const double GUTTER_SIZE = 32;
  static const double BORDER_RADIUS = 16;

  final KChatMessage chat;
  final KChatMessage? previousChat;
  final KChatMessage? nextChat;
  final Function(KUser)? onAvatarClick;

  bool get isFirstOfSeries {
    if (this.previousChat == null ||
        this.previousChat?.messageDate == null ||
        this.chat.messageDate == null) return true;
    bool isDifferentUser = this.previousChat?.puid != this.chat.puid;
    bool isPastTimeCutoff = this
            .chat
            .messageDate!
            .difference(this.previousChat!.messageDate!)
            .abs() >
        SHORT_TIME_CUTOFF;
    return isDifferentUser || isPastTimeCutoff;
  }

  bool get isLastOfSeries =>
      this.nextChat == null ||
      this.nextChat?.puid != this.chat.puid ||
      this.chat.messageDate == null ||
      this.chat.messageDate!.difference(this.nextChat!.messageDate!).abs() >
          SHORT_TIME_CUTOFF;

  bool get isShowTimestamp =>
      this.previousChat == null ||
      this.chat.messageDate == null ||
      this.previousChat?.messageDate == null ||
      this.chat.messageDate!.difference(this.previousChat!.messageDate!).abs() >
          LONG_TIME_CUTOFF;

  /// Kinda complex rule-set for determining chat bubble border radius
  BorderRadiusGeometry get chatBorderRadius {
    BorderRadiusGeometry br = this.chat.isMe
        ? BorderRadius.horizontal(left: Radius.circular(BORDER_RADIUS))
        : BorderRadius.horizontal(right: Radius.circular(BORDER_RADIUS));
    if (this.isFirstOfSeries) {
      if (this.chat.isMe)
        br =
            br.add(BorderRadius.only(topRight: Radius.circular(BORDER_RADIUS)));
      else
        br = br.add(BorderRadius.only(topLeft: Radius.circular(BORDER_RADIUS)));
    }
    if (this.isLastOfSeries) {
      if (this.chat.isMe)
        br = br.add(
            BorderRadius.only(bottomRight: Radius.circular(BORDER_RADIUS)));
      else
        br = br
            .add(BorderRadius.only(bottomLeft: Radius.circular(BORDER_RADIUS)));
    }
    return br;
  }

  const KChatBubble(
    this.chat, {
    this.previousChat,
    this.nextChat,
    this.onAvatarClick,
  });

  void onImageClick(ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (c) =>
            Scaffold(body: KImageViewer(imageURL: this.chat.message)),
      ),
    );
  }

  Widget wrapWithChatBubble(Widget child, Color chatBGColor) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: this.chatBorderRadius,
          color: this.chat.isLocal ? Colors.blue[50] : chatBGColor,
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatBGColor = this.chat.isMe
        ? theme.colorScheme.primary
        : theme.primaryColor.withOpacity(0.05);
    final chatForegroundColor =
        this.chat.isMe ? Colors.white : theme.primaryColor;

    final content;
    switch (this.chat.messageType ?? "") {
      case KChatMessage.CONTENT_TYPE_TEXT:
        content = wrapWithChatBubble(
          Text(
            this.chat.message ?? "",
            style:
                theme.textTheme.subtitle1!.copyWith(color: chatForegroundColor),
          ),
          chatBGColor,
        );
        break;
      case KChatMessage.CONTENT_TYPE_IMAGE:
        content = ClipRRect(
          borderRadius: BorderRadius.circular(BORDER_RADIUS),
          child: Container(
            width: MediaQuery.of(context).size.height / 2,
            child: this.chat.message == null && this.chat.imageData == null
                ? FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Icon(Icons.broken_image),
                  )
                : InkWell(
                    onTap: () => onImageClick(context),
                    child: FadeInImage(
                      placeholder: AssetImage(KAssets.IMG_TRANSPARENCY),
                      image: this.chat.imageData != null
                          ? MemoryImage(base64Decode(this.chat.imageData!))
                              as ImageProvider<Object>
                          : NetworkImage(this.chat.message!),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 100),
                    ),
                  ),
          ),
        );
        break;
      case KChatMessage.CONTENT_TYPE_VIDEO_CALL_EVENT:
        content = wrapWithChatBubble(
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.video_call, color: chatForegroundColor),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      "Video call from ${this.chat.kUser?.firstName ?? "user"}",
                      style: theme.textTheme.subtitle1!
                          .copyWith(color: chatForegroundColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "${KUtil.prettyDate(this.chat.messageDate, showTime: true)}",
                style: theme.textTheme.caption!
                    .copyWith(color: chatForegroundColor),
              ),
            ],
          ),
          chatBGColor,
        );
        break;
      default:
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: theme.errorColor),
            SizedBox(width: 4),
            Text(
              "An error occurred",
              style:
                  theme.textTheme.bodyText1!.copyWith(color: theme.errorColor),
            ),
          ],
        );
        break;
    }

    final userIcon = GestureDetector(
      onTap: () => this.onAvatarClick?.call(this.chat.kUser!),
      child: ClipOval(
        child: Container(
          width: GUTTER_SIZE,
          height: GUTTER_SIZE,
          child: KUserAvatar.fromUser(this.chat.kUser),
        ),
      ),
    );

    final fbSideGutter = Container(
      width: GUTTER_SIZE,
      height: GUTTER_SIZE,
      child: this.isLastOfSeries && !this.chat.isMe ? userIcon : Container(),
    );

    final fbStyleBody = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!this.chat.isMe) ...[
          fbSideGutter,
          SizedBox(width: 10),
        ],
        if (this.chat.isMe) Spacer(flex: 3),
        Expanded(
          flex: 7,
          child: Align(
            alignment:
                this.chat.isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: content,
          ),
        ),
        if (!this.chat.isMe) Spacer(flex: 3),
      ],
    );

    final body = this.isShowTimestamp
        ? Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    KUtil.timeAgo(this.chat.messageDate),
                    style: theme.textTheme.bodyText2,
                  ),
                ),
              ),
              fbStyleBody,
            ],
          )
        : fbStyleBody;

    final masterPadding = EdgeInsets.symmetric(horizontal: 2, vertical: 1);

    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Container(
        padding: this.isFirstOfSeries
            ? masterPadding.copyWith(top: 10)
            : masterPadding,
        child: body,
      ),
    );
  }
}
