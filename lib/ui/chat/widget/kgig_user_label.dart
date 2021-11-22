import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/ui/chat/widget/kuser_profile_view.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';

class KGigUserLabel extends StatelessWidget {
  final KUser user;

  KGigUserLabel(this.user);

  factory KGigUserLabel.build({
    required String name,
    required String image,
    required String rating,
    required String title,
    required String puid,
  }) =>
      KGigUserLabel(KUser()
        ..puid = puid
        ..firstName = name
        ..avatarURL = image);

  String? get title => "@${user.kunm}";

  void onClick(context) => Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => KUserProfileView.fromUser(this.user)));

  @override
  Widget build(BuildContext context) {
    final image = KUserAvatar(
      initial: this.user.firstName,
      imageURL: this.user.avatarURL,
    );

    final nameView = FittedBox(
      fit: BoxFit.contain,
      child: Text(
        this.user.firstName ?? "",
        overflow: TextOverflow.clip,
        softWrap: false,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: KStyles.fontSizeNormal,
        ),
      ),
    );

    final titleView = Text(
      this.title ?? "",
      style: TextStyle(fontSize: KStyles.fontSizeSmall),
    );

    // final ratingField = ReviewField.readOnly(this.user.userRating ?? "");

    final body = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: image),
        SizedBox(width: 8),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: nameView),
              if (KStringHelper.isExist(this.title)) ...[
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: titleView,
                  ),
                ),
              ],
              // Flexible(
              //   child: this.user.userRating == null
              //       ? Text("No rating", style: KStyles.detailText)
              //       : ratingField,
              // ),
            ],
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => onClick(context),
      child: body,
    );
  }
}
