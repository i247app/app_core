// import 'package:app_core/helper/throttle_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:app_core/helper/string_helper.dart';
// import 'package:app_core/model/user.dart';
// import 'package:app_core/ui/chat/widget/user_profile_view.dart';
// import 'package:app_core/value/styles.dart';
//
// // import 'package:app_core/widget/review_field.dart';
// import 'package:app_core/widget/user_avatar.dart';
//
// class GigUserLabel extends StatelessWidget {
//   final User user;
//
//   GigUserLabel(this.user);
//
//   factory GigUserLabel.build({
//     required String name,
//     required String image,
//     required String rating,
//     required String title,
//     required String puid,
//   }) =>
//       GigUserLabel(User()
//         ..puid = puid
//         ..firstName = name
//         ..avatarURL = image);
//
//   String? get title {
//     return "@${user.kunm}";
//   }
//
//   void onClick(context) => Navigator.of(context).push(
//       MaterialPageRoute(builder: (ctx) => UserProfileView(user: this.user)));
//
//   @override
//   Widget build(BuildContext context) {
//     final image = UserAvatar(
//       initial: this.user.firstName,
//       imageURL: this.user.avatarURL,
//     );
//
//     final nameView = FittedBox(
//       fit: BoxFit.contain,
//       child: Text(
//         this.user.firstName ?? "",
//         overflow: TextOverflow.clip,
//         softWrap: false,
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: Styles.fontSizeNormal,
//         ),
//       ),
//     );
//
//     final titleView = Text(
//       this.title ?? "",
//       style: TextStyle(fontSize: Styles.fontSizeSmall),
//     );
//
//     // final ratingField = ReviewField.readOnly(this.user.userRating ?? "");
//
//     final body = Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Flexible(child: image),
//         SizedBox(width: 8),
//         Flexible(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Flexible(child: nameView),
//               if (StringHelper.isExist(this.title)) ...[
//                 Flexible(
//                   child: FittedBox(
//                     fit: BoxFit.contain,
//                     child: titleView,
//                   ),
//                 ),
//               ],
//               // Flexible(
//               //   child: this.user.userRating == null
//               //       ? Text("No rating", style: Styles.detailText)
//               //       : ratingField,
//               // ),
//             ],
//           ),
//         ),
//       ],
//     );
//
//     return GestureDetector(
//       onTap: () => onClick(context),
//       child: body,
//     );
//   }
// }
