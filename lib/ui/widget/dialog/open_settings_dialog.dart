import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_core/header/styles.dart';

class AppCoreOpenSettingsDialog extends StatelessWidget {
  final String body;
  final String? title;

  const AppCoreOpenSettingsDialog({
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
            style: Styles.normalText.copyWith(color: Styles.extraDarkGrey),
          ),
        ),
        ElevatedButton(
          onPressed: () => openAppSettings()
              .whenComplete(() => Navigator.of(context).pop(true)),
          style: ElevatedButton.styleFrom(
            primary: Styles.colorBGYes,
            onPrimary: Styles.colorButtonText,
          ),
          child: Text(
            "Open Settings",
            style: Styles.normalText.copyWith(color: Styles.white),
          ),
        ),
      ],
    );

    return body;
  }
}
