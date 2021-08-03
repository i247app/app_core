import 'package:app_core/style/ktheme.dart';
import 'package:flutter/widgets.dart';

class KStyleManager extends InheritedWidget {
  final KTheme theme;

  const KStyleManager({
    required Widget child,
    required this.theme,
  }) : super(child: child);

  static KStyleManager of(BuildContext context) {
    final KStyleManager? result =
        context.dependOnInheritedWidgetOfExactType<KStyleManager>();
    assert(result != null, 'No KStyleManager found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(KStyleManager old) => this.theme != old.theme;
}
