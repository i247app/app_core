import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BooleanDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? yesText;
  final String? noText;
  final bool valence; // Is the 'yes' action a positive or negative?

  Color get yesColor => valence ? KStyles.colorBGYes : KStyles.colorBGNo;

  const BooleanDialog({
    this.content,
    this.title,
    this.yesText,
    this.noText,
    this.valence = true,
  });

  @override
  Widget build(BuildContext context) {
    final body = AlertDialog(
      title: title == null ? null : Text(title!),
      content: content == null ? null : Text(content!),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
          child: Text(noText ?? "No"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            primary: yesColor,
            onPrimary: Colors.white,
          ),
          child: Text(yesText ?? "Yes", style: KStyles.normalText),
        ),
      ],
    );

    return body;
  }
}
