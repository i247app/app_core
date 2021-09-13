import 'package:app_core/app_core.dart';
import 'package:app_core/header/kstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatDisplayName extends StatelessWidget {
  final String? kunm;
  final String? lnm;
  final String? mnm;
  final String? fnm;

  ChatDisplayName({
    this.kunm,
    this.lnm,
    this.mnm,
    this.fnm,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: context.textTheme.subtitle1,
        children: <TextSpan>[
          if (this.kunm != null && !KStringHelper.isEmpty(this.kunm))
            TextSpan(
                text: '@${this.kunm} ', style: context.textTheme.subtitle2),
          TextSpan(
              text: KUtil.prettyName(
                      lnm: this.lnm ?? "",
                      mnm: this.mnm ?? "",
                      fnm: this.fnm ?? "") ??
                  ""),
        ],
      ),
    );
  }
}
