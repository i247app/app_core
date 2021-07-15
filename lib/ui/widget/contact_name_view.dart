import 'package:app_core/helper/util.dart';
import 'package:app_core/model/user.dart';
import 'package:app_core/header/kstyles.dart';
import 'package:flutter/material.dart';

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
        style: TextStyle(color: KStyles.black, fontSize: 16),
        children: <TextSpan>[
          if (this.kunm != null && (this.kunm ?? "").isNotEmpty)
            TextSpan(
              text: '@${this.kunm} ',
              style: TextStyle(color: KStyles.colorPrimary, fontSize: 16),
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
