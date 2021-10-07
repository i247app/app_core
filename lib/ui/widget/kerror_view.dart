import 'package:app_core/header/kstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KErrorView extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const KErrorView(this.errorDetails);

  @override
  Widget build(BuildContext context) {
    final label = Text(
      "Oops, an error occurred! We'll fix this soon.",
      textAlign: TextAlign.center,
      style: KStyles.largeText,
    );

    final body = Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.red),
        color: Colors.red.withOpacity(0.5),
      ),
      child: label,
    );

    return body;
  }
}
