import 'package:app_core/header/kstyles.dart';
import 'package:flutter/widgets.dart';

class KErrorView extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const KErrorView(this.errorDetails);

  @override
  Widget build(BuildContext context) {
    final body = Text(
      "Oops, an error occurred! We'll fix this soon.",
      textAlign: TextAlign.center,
      style: KStyles.largeText,
    );

    return body;
  }
}
