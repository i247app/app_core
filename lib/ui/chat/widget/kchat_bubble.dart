import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/chapter.dart';
import 'package:app_core/ui/school/widget/kdoc_screen.dart';
import 'package:app_core/ui/school/widget/kdoc_view.dart';
import 'package:app_core/ui/widget/kimage_viewer.dart';
import 'package:app_core/ui/widget/ksmart_image.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';

class KChatBubble extends StatelessWidget {
  static const Duration SHORT_TIME_CUTOFF = Duration(minutes: 2);
  static const Duration LONG_TIME_CUTOFF = Duration(minutes: 10);
  static const double GUTTER_SIZE = 32;
  static const double BORDER_RADIUS = 16;

  final List<KChatMember>? members;
  final KChatMessage msg;
  final KChatMessage? previousMsg;
  final KChatMessage? nextMsg;
  final Function(KUser)? onAvatarClick;
  final Function()? onReload;

  bool get isFirstOfSeries {
    if (this.previousMsg == null ||
        this.previousMsg?.messageDate == null ||
        this.msg.messageDate == null) return true;
    final isDifferentUser = this.previousMsg?.puid != this.msg.puid;
    final isPastTimeCutoff =
        this.msg.messageDate!.difference(this.previousMsg!.messageDate!).abs() >
            SHORT_TIME_CUTOFF;
    return isDifferentUser || isPastTimeCutoff;
  }

  bool get isLastOfSeries =>
      this.nextMsg == null ||
      this.nextMsg?.puid != this.msg.puid ||
      this.msg.messageDate == null ||
      this.msg.messageDate!.difference(this.nextMsg!.messageDate!).abs() >
          SHORT_TIME_CUTOFF;

  bool get isShowTimestamp =>
      this.previousMsg == null ||
      this.msg.messageDate == null ||
      this.previousMsg?.messageDate == null ||
      this.msg.messageDate!.difference(this.previousMsg!.messageDate!).abs() >
          LONG_TIME_CUTOFF;

  bool get amIInThisChat =>
      members == null ||
      (members ?? [])
          .map<String?>((m) => m.puid)
          .contains(KSessionData.me?.puid ?? "?");

  bool get isAlignLeft {
    final insider = !msg.isMe;
    if (amIInThisChat) {
      return insider;
    }
    bool? outsider;
    try {
      // Alternate right-left scheme when viewing other ppls' chat
      outsider = msg.puid !=
          (members?..sort((a, b) => a.puid!.compareTo(b.puid!)))![1].puid;
    } catch (_) {}
    return outsider == null ? insider : outsider;
  }

  bool get isAlignRight {
    final insider = msg.isMe;
    if (amIInThisChat) {
      return insider;
    }
    bool? outsider;
    try {
      // Alternate right-left scheme when viewing other ppls' chat
      outsider = msg.puid ==
          (members?..sort((a, b) => a.puid!.compareTo(b.puid!)))![1].puid;
    } catch (_) {}
    return outsider == null ? insider : outsider;
  }

  // bool get isAlignRight => (amIInThisChat && msg.isMe);

  /// Kinda complex rule-set for determining chat bubble border radius
  BorderRadiusGeometry get chatBorderRadius {
    BorderRadiusGeometry br = this.msg.isMe
        ? BorderRadius.horizontal(left: Radius.circular(BORDER_RADIUS))
        : BorderRadius.horizontal(right: Radius.circular(BORDER_RADIUS));
    if (this.isFirstOfSeries) {
      if (this.msg.isMe) {
        br =
            br.add(BorderRadius.only(topRight: Radius.circular(BORDER_RADIUS)));
      } else {
        br = br.add(BorderRadius.only(topLeft: Radius.circular(BORDER_RADIUS)));
      }
    }
    if (this.isLastOfSeries) {
      if (this.msg.isMe) {
        br = br.add(
            BorderRadius.only(bottomRight: Radius.circular(BORDER_RADIUS)));
      } else {
        br = br
            .add(BorderRadius.only(bottomLeft: Radius.circular(BORDER_RADIUS)));
      }
    }

    return br;
  }

  const KChatBubble(
    this.msg, {
    this.members,
    this.previousMsg,
    this.nextMsg,
    this.onAvatarClick,
    this.onReload,
  });

  void onImageMessageClick(ctx, KChatMessage msg) {
    if (msg.messageType == KChatMessage.CONTENT_TYPE_IMAGE) {
      Navigator.of(ctx).push(MaterialPageRoute(
          builder: (c) => Scaffold(body: KImageViewer.network(msg.message))));
    }
  }

  void onChapterClick(ctx, String encodedIDs) async {
    // KToastHelper.success("Chapter $chapterID");

    // Load in chapter
    Chapter? chapter;
    String? ssID;
    try {
      final textbookID = encodedIDs.split("::")[0];
      final chapterID = encodedIDs.split("::")[1];
      ssID = encodedIDs.split("::")[2];
      chapter = await KServerHandler.getTextbook(
              textbookID: textbookID, chapterID: chapterID)
          .then((r) => r.textbooks!.first.chapters!.first);
    } catch (_) {
      chapter = null;
    }

    final screen = KDocScreen(
      chapter: chapter!,
      mode: KDocViewMode.movable,
      ssID: ssID,
    );
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => screen));
  }

  Widget wrapWithChatBubble(Widget child, Color chatBGColor) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: chatBorderRadius,
          color: msg.isLocal ? Colors.blue[50] : chatBGColor,
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatBGColor = this.msg.isMe
        ? theme.colorScheme.primary
        : theme.primaryColor.withOpacity(0.05);
    final chatForegroundColor =
        this.msg.isMe ? Colors.white : theme.primaryColor;
    // final imageView = Image.network(
    //   this.msg.message!,
    //   frameBuilder: (BuildContext context, Widget child, int? frame,
    //       bool wasSynchronouslyLoaded) {
    //     if (wasSynchronouslyLoaded) {
    //       return child;
    //     }
    //     return AnimatedOpacity(
    //       opacity: frame == null ? 0 : 1,
    //       duration: const Duration(milliseconds: 100),
    //       curve: Curves.easeOut,
    //       child: InkWell(
    //         child: child,
    //         onTap: () => onImageMessageClick(context, msg),
    //       ),
    //     );
    //   },
    //   errorBuilder: (context, error, stackTrace) {
    //     return InkWell(
    //       onTap: () => this.onReload?.call(),
    //       child: Card(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: <Widget>[
    //               Icon(Icons.replay_outlined),
    //               Text("Tap to reload"),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
    final content;
    switch (msg.messageType ?? "") {
      case KChatMessage.CONTENT_TYPE_TEXT:
        content = wrapWithChatBubble(
          Text(
            msg.message ?? "",
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
            child: this.msg.message == null && this.msg.imageData == null
                ? FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Icon(Icons.broken_image),
                  )
                : KSmartImage(
                    // key: Key(msg.messageID ?? "?"),
                    base64Data: msg.imageData,
                    url: msg.message,
                    onClick: () => onImageMessageClick(context, msg),
                  ),
            // FadeInImage(
            //   placeholder: AssetImage(KAssets.IMG_TRANSPARENCY),
            //   image: this.msg.imageData != null
            //       ? MemoryImage(base64Decode(this.msg.imageData!))
            //           as ImageProvider<Object>
            //       : NetworkImage(this.msg.message!),
            //   fit: BoxFit.contain,
            //   fadeInDuration: Duration(milliseconds: 100),
            // ),
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
                      "Video call from ${this.msg.user?.firstName ?? "user"}",
                      style: theme.textTheme.subtitle1!
                          .copyWith(color: chatForegroundColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "${KUtil.prettyDate(this.msg.messageDate, showTime: true)}",
                style: theme.textTheme.caption!
                    .copyWith(color: chatForegroundColor),
              ),
            ],
          ),
          chatBGColor,
        );
        break;
      case KChatMessage.CONTENT_TYPE_CHAPTER:
        content = GestureDetector(
          onTap: () => onChapterClick(context, msg.message ?? "?"),
          child: wrapWithChatBubble(
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.book, color: chatForegroundColor),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        () {
                          String str;
                          try {
                            final tokens = msg.message!.split("::");
                            final title = tokens[3];
                            final chapterNumber = tokens[4];
                            final grade = tokens[5];
                            str = "$title (Lop $grade Bai $chapterNumber)";
                          } catch (_) {
                            str = "textbook";
                          }
                          return "Tap to view $str";
                        }.call(),
                        style: theme.textTheme.subtitle1!
                            .copyWith(color: chatForegroundColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  "${KUtil.prettyDate(msg.messageDate, showTime: true)}",
                  style: theme.textTheme.caption!
                      .copyWith(color: chatForegroundColor),
                ),
              ],
            ),
            chatBGColor,
          ),
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
      onTap: () => onAvatarClick?.call(this.msg.user!),
      child: ClipOval(
        child: Container(
          width: GUTTER_SIZE,
          height: GUTTER_SIZE,
          child: KUserAvatar.fromUser(this.msg.user),
        ),
      ),
    );

    final fbSideGutter = Container(
      width: GUTTER_SIZE,
      height: GUTTER_SIZE,
      child: isLastOfSeries && (!amIInThisChat || !msg.isMe)
          ? userIcon
          : Container(),
    );

    final fbStyleBody = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isAlignLeft) ...[
          fbSideGutter,
          SizedBox(width: 10),
        ],
        if (isAlignRight) Spacer(flex: 3),
        Expanded(
          flex: 7,
          child: Align(
            alignment:
                isAlignRight ? Alignment.centerRight : Alignment.centerLeft,
            child: content,
          ),
        ),
        if (isAlignLeft) Spacer(flex: 3),
        if (isAlignRight && !amIInThisChat) ...[
          SizedBox(width: 10),
          fbSideGutter,
        ],
      ],
    );

    final body = this.isShowTimestamp
        ? Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    KUtil.timeAgo(this.msg.messageDate),
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
