import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';

class KLocationPermissionInfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = Row(
      children: [
        Icon(Icons.location_pin, color: KStyles.colorSecondary),
        SizedBox(width: 4),
        Text("Location Access"),
      ],
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "This app collects location data to enable finding nearby promotion even when the app is closed or not in use or in background. Without this core feature, the app is broken or rendered unusable.",
          style: TextStyle(height: 1.2),
        ),
      ],
    );

    final body = AlertDialog(
      title: title,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: KStyles.black,
      ),
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            textStyle: TextStyle(color: KStyles.colorSecondary),
          ),
          child: Text("Ok"),
        ),
      ],
    );

    return body;
  }
}
