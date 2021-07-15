import 'package:flutter/widgets.dart';

class AppCoreKeyboardKiller extends StatelessWidget {
  final Widget child;

  AppCoreKeyboardKiller({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
