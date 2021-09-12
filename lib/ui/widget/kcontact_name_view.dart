import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/kuser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KContactNameView extends StatelessWidget {
  final String? kunm;
  final String? fnm;
  final String? mnm;
  final String? lnm;

  KContactNameView({
    this.kunm,
    this.fnm,
    this.mnm,
    this.lnm,
  });

  factory KContactNameView.fromUser(KUser user) => KContactNameView(
        kunm: user.kunm,
        lnm: user.lastName,
        mnm: user.middleName,
        fnm: user.firstName,
      );

  @override
  Widget build(BuildContext context) {
    final body = RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: context.textTheme.subtitle1,
        children: <TextSpan>[
          if (this.kunm != null && (this.kunm ?? "").isNotEmpty)
            TextSpan(
              text: '@${this.kunm} ',
              style: context.textTheme.subtitle1
                  ?.copyWith(color: context.theme.primaryColor),
            ),
          TextSpan(
            text: KUtil.prettyName(
                  lnm: this.lnm ?? "",
                  mnm: this.mnm ?? "",
                  fnm: this.fnm ?? "",
                ) ??
                "",
          ),
        ],
      ),
    );

    return body;
  }
}
