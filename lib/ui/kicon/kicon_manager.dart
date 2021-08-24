import 'package:flutter/widgets.dart';

// typedef KIconSet = Map<dynamic, KIconProvider>;

class KIconProvider {
  final IconData? iconData;
  final String? assetPath;

  const KIconProvider.icon(this.iconData) : this.assetPath = null;

  const KIconProvider.asset(this.assetPath) : this.iconData = null;

  dynamic get resource {
    assert(this.iconData != null || this.assetPath != null,
        "KIconProvider.resource no resource provided");
    return this.iconData == null ? this.assetPath : this.iconData;
  }
}

class KIconManager extends InheritedWidget {
  final Map<dynamic, KIconProvider> iconSet;

  const KIconManager({
    required Widget child,
    required this.iconSet,
  }) : super(child: child);

  static KIconManager of(BuildContext context) {
    final KIconManager? result =
        context.dependOnInheritedWidgetOfExactType<KIconManager>();
    assert(result != null, 'No KIconManager found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(KIconManager old) => this.iconSet != old.iconSet;

  void changeIconSet(Map<dynamic, KIconProvider> newIconSet) {
    this.iconSet.clear();
    this.iconSet.addAll(newIconSet);
  }
}
