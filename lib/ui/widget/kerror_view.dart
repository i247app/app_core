import 'package:app_core/header/kold_styles.dart';
import 'package:flutter/widgets.dart';

class KErrorView extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const KErrorView(this.errorDetails);

  @override
  Widget build(BuildContext context) {
    final body = Text(
      "Oops, an error occurred! We'll fix this soon.",
      textAlign: TextAlign.center,
      style: KOldStyles.largeText,
    );

    return body;
  }
}
