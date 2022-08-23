import 'package:app_core/value/kphrases.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';

class KErrorView extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const KErrorView(this.errorDetails);

  @override
  Widget build(BuildContext context) {
    final label = Text(
      KPhrases.anErrorOccurred,
      // "Oops, an error occurred! We'll fix this soon.",
      textAlign: TextAlign.center,
      style: KStyles.largeText,
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("😅", style: TextStyle(fontSize: 64)),
        SizedBox(height: 10),
        label,
      ],
    );

    final body = Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: content,
    );

    return Center(child: Material(child: SafeArea(child: body)));
  }
}
