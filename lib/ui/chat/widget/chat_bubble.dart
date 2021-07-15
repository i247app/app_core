// import 'dart:convert';
//
// import 'package:app_core/app_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:app_core/lingo/phrases.dart';
// import 'package:app_core/helper/util.dart';
// import 'package:app_core/model/chat_message.dart';
// import 'package:app_core/value/assets.dart';
// import 'package:app_core/value/styles.dart';
// import 'package:app_core/widget/image_viewer.dart';
// import 'package:app_core/widget/user_avatar.dart';
//
// class ChatBubble extends StatelessWidget {
//   static const Duration SHORT_TIME_CUTOFF = Duration(minutes: 2);
//   static const Duration LONG_TIME_CUTOFF = Duration(minutes: 10);
//   static const double GUTTER_SIZE = 32;
//   static const double BORDER_RADIUS = 16;
//
//   final ChatMessage chat;
//   final ChatMessage? previousChat;
//   final ChatMessage? nextChat;
//   final Function(String)? onAvatarClick;
//
//   bool get isFirstOfSeries {
//     if (this.previousChat == null ||
//         this.previousChat?.messageDate == null ||
//         this.chat.messageDate == null) return true;
//     bool isDifferentUser = this.previousChat?.puid != this.chat.puid;
//     bool isPastTimeCutoff = this
//             .chat
//             .messageDate!
//             .difference(this.previousChat!.messageDate!)
//             .abs() >
//         SHORT_TIME_CUTOFF;
//     return isDifferentUser || isPastTimeCutoff;
//   }
//
//   bool get isLastOfSeries =>
//       this.nextChat == null ||
//       this.nextChat?.puid != this.chat.puid ||
//       this.chat.messageDate == null ||
//       this.chat.messageDate!.difference(this.nextChat!.messageDate!).abs() >
//           SHORT_TIME_CUTOFF;
//
//   bool get isShowTimestamp =>
//       this.previousChat == null ||
//       this.chat.messageDate == null ||
//       this.previousChat?.messageDate == null ||
//       this.chat.messageDate!.difference(this.previousChat!.messageDate!).abs() >
//           LONG_TIME_CUTOFF;
//
//   Color get chatBGColor =>
//       this.chat.isMe ? Styles.colorPrimary : Styles.extraExtraLightGrey;
//
//   Color get chatTextColor => this.chat.isMe ? Styles.white : Styles.black;
//
//   /// Kinda complex rule-set for determining chat bubble border radius
//   BorderRadiusGeometry get chatBorderRadius {
//     BorderRadiusGeometry br = this.chat.isMe
//         ? BorderRadius.horizontal(left: Radius.circular(BORDER_RADIUS))
//         : BorderRadius.horizontal(right: Radius.circular(BORDER_RADIUS));
//     if (this.isFirstOfSeries) {
//       if (this.chat.isMe)
//         br =
//             br.add(BorderRadius.only(topRight: Radius.circular(BORDER_RADIUS)));
//       else
//         br = br.add(BorderRadius.only(topLeft: Radius.circular(BORDER_RADIUS)));
//     }
//     if (this.isLastOfSeries) {
//       if (this.chat.isMe)
//         br = br.add(
//             BorderRadius.only(bottomRight: Radius.circular(BORDER_RADIUS)));
//       else
//         br = br
//             .add(BorderRadius.only(bottomLeft: Radius.circular(BORDER_RADIUS)));
//     }
//     return br;
//   }
//
//   const ChatBubble(
//     this.chat, {
//     this.previousChat,
//     this.nextChat,
//     this.onAvatarClick,
//   });
//
//   void onImageClick(ctx) {
//     Navigator.of(ctx).push(
//       MaterialPageRoute(
//         builder: (c) =>
//             Scaffold(body: ImageViewer(imageURL: this.chat.message)),
//       ),
//     );
//   }
//
//   Widget wrapWithChatBubble(Widget child) => Container(
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//         decoration: BoxDecoration(
//           borderRadius: this.chatBorderRadius,
//           color: this.chat.isLocal ? Styles.blueFaded : this.chatBGColor,
//         ),
//         child: child,
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     final content;
//     switch (this.chat.messageType ?? "") {
//       case AppCoreChatMessageType.CONTENT_TYPE_TEXT:
//         content = wrapWithChatBubble(
//           Text(
//             this.chat.message ?? "",
//             style: TextStyle(fontSize: 17, color: this.chatTextColor),
//           ),
//         );
//         break;
//       case AppCoreChatMessageType.CONTENT_TYPE_IMAGE:
//         content = ClipRRect(
//           borderRadius: BorderRadius.circular(BORDER_RADIUS),
//           child: Container(
//             width: MediaQuery.of(context).size.height / 2,
//             child: this.chat.message == null && this.chat.imageData == null
//                 ? FittedBox(
//                     fit: BoxFit.fitWidth,
//                     child: Icon(Icons.broken_image),
//                   )
//                 : InkWell(
//                     onTap: () => onImageClick(context),
//                     child: FadeInImage(
//                       placeholder: AssetImage(Assets.IMG_TRANSPARENCY),
//                       image: this.chat.imageData != null
//                           ? MemoryImage(base64Decode(this.chat.imageData!))
//                               as ImageProvider<Object>
//                           : NetworkImage(this.chat.message!),
//                       fit: BoxFit.contain,
//                       fadeInDuration: Duration(milliseconds: 100),
//                     ),
//                   ),
//           ),
//         );
//         break;
//       case AppCoreChatMessageType.CONTENT_TYPE_VIDEO_CALL_EVENT:
//         content = wrapWithChatBubble(
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.video_call, color: this.chatTextColor),
//                   SizedBox(width: 10),
//                   Flexible(
//                     child: Text(
//                       "Video call from ${this.chat.user?.firstName ?? "user"}",
//                       style: TextStyle(fontSize: 17, color: this.chatTextColor),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 4),
//               Text(
//                 "${Util.prettyDate(this.chat.messageDate, showTime: true)}",
//                 style: Styles.detailText
//                     .copyWith(color: this.chatTextColor)
//                     .apply(),
//               ),
//             ],
//           ),
//         );
//         break;
//       default:
//         content = Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.error, color: Styles.colorError),
//             SizedBox(width: 4),
//             Text(
//               Phrases.anErrorOccurred,
//               style: TextStyle(color: Styles.colorError),
//             ),
//           ],
//         );
//         break;
//     }
//
//     final userIcon = GestureDetector(
//       onTap: () => this.onAvatarClick?.call(this.chat.puid!),
//       child: ClipOval(
//         child: Container(
//           width: GUTTER_SIZE,
//           height: GUTTER_SIZE,
//           child: UserAvatar.fromUser(this.chat.user),
//         ),
//       ),
//     );
//
//     final fbSideGutter = Container(
//       width: GUTTER_SIZE,
//       height: GUTTER_SIZE,
//       child: this.isLastOfSeries && !this.chat.isMe ? userIcon : Container(),
//     );
//
//     final fbStyleBody = Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         if (!this.chat.isMe) ...[
//           fbSideGutter,
//           SizedBox(width: 10),
//         ],
//         if (this.chat.isMe) Spacer(flex: 3),
//         Expanded(
//           flex: 7,
//           child: Align(
//             alignment:
//                 this.chat.isMe ? Alignment.centerRight : Alignment.centerLeft,
//             child: content,
//           ),
//         ),
//         if (!this.chat.isMe) Spacer(flex: 3),
//       ],
//     );
//
//     final body = this.isShowTimestamp
//         ? Column(
//             children: [
//               Center(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 20),
//                   child: Text(
//                     Util.timeAgo(this.chat.messageDate),
//                     style: Styles.detailText,
//                   ),
//                 ),
//               ),
//               fbStyleBody,
//             ],
//           )
//         : fbStyleBody;
//
//     final masterPadding = EdgeInsets.symmetric(horizontal: 2, vertical: 1);
//
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.5,
//       child: Container(
//         padding: this.isFirstOfSeries
//             ? masterPadding.copyWith(top: 10)
//             : masterPadding,
//         child: body,
//       ),
//     );
//   }
// }
