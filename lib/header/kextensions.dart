import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/widgets.dart';

extension KList<T> on List<T> {
  /// Insert an element 't' between each list item
  List<T> intersperse(T t, {bool addToEnd = false}) {
    final result = <T>[];
    for (int i = 0; i < this.length; i++) {
      result.add(this[i]);
      final isLastItem = i == (this.length - 1);
      if (!isLastItem || addToEnd) result.add(t);
    }
    return result;
  }

  /// Remove duplicates
  Iterable<T> unique(dynamic Function(T) extractor) => map(
          (e) => extractor(e)) // extract IDs
      .toSet() // remove duplicates
      .map((e1) =>
          firstWhereOrNull((e2) => e1 == extractor(e2))) // pick 1 matching item
      .where((e) => e != null) // remove nulls
      .cast<T>();
}

extension KWidget<T> on State<StatefulWidget> {
  bool isKeyboardVisible() {
    final insets = MediaQuery.of(this.context).viewInsets;
    return insets.bottom != 0;
  }

  bool isKeyboardHidden() => !isKeyboardVisible();

  void safeSetState(f) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(f);
    }
  }
}
