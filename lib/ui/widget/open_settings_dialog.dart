import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class KSettingsDialog extends StatelessWidget {
  final String body;
  final String? title;

  const KSettingsDialog({
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
          ),
        ),
        ElevatedButton(
          onPressed: () => openAppSettings()
              .whenComplete(() => Navigator.of(context).pop(true)),
          child: Text(
            "Open Settings",
          ),
        ),
      ],
    );

    return body;
  }
}
