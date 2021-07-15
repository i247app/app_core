import 'package:app_core/header/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppCoreLocationPermissionInfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = Row(
      children: [
        Icon(Icons.location_pin, color: Styles.colorSecondary),
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
        color: Styles.black,
      ),
      content: content,
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            "Ok",
            style: TextStyle(color: Styles.colorSecondary),
          ),
        ),
      ],
    );

    return body;
  }
}
