import 'package:flutter/widgets.dart';

class KeyboardKiller extends StatelessWidget {
  final Widget child;

  KeyboardKiller({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: this.child,
    );
  }
}
