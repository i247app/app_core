import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_core/header/kold_styles.dart';

class KOpenSettingsDialog extends StatelessWidget {
  final String body;
  final String? title;

  const KOpenSettingsDialog({
    required this.body,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final body = AlertDialog(
      title: this.title == null ? null : Text(this.title ?? ""),
      content: Text(this.body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            "Cancel",
            style: KOldStyles.normalText.copyWith(color: KOldStyles.extraDarkGrey),
          ),
        ),
        ElevatedButton(
          onPressed: () => openAppSettings()
              .whenComplete(() => Navigator.of(context).pop(true)),
          style: ElevatedButton.styleFrom(
            primary: KOldStyles.colorBGYes,
            onPrimary: KOldStyles.colorButtonText,
          ),
          child: Text(
            "Open Settings",
            style: KOldStyles.normalText.copyWith(color: KOldStyles.white),
          ),
        ),
      ],
    );

    return body;
  }
}
