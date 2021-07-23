import 'package:flutter/widgets.dart';

class KEmbedManager extends InheritedWidget {
  final bool isEmbed;

  const KEmbedManager({
    required Widget child,
    required this.isEmbed,
  }) : super(child: child);

  static KEmbedManager of(BuildContext context) {
    final KEmbedManager? result =
        context.dependOnInheritedWidgetOfExactType<KEmbedManager>();
    assert(result != null, 'No EmbedManager found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(KEmbedManager old) => this.isEmbed != old.isEmbed;
}
