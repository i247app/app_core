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
  Iterable<T> unique(dynamic Function(T) extractor) {
    // rawTutorGigs
    //     ?.map((tg) => tg.gigID) // get all current IDs
    //     .map((id) => rawTutorGigs
    //     ?.firstWhereOrNull((rtg) => rtg.gigID == id)) // get 1 gig per ID
    //     .where((tg) => tg?.gigStatus != null) // filter out null gigs
    //     .cast<TutorGig>()
    //     .toList()
    return map((e) => extractor(e))
        .map((e1) => firstWhereOrNull((e2) => e1 == extractor(e2)))
        .where((e) => e != null)
        .cast<T>();
  }
}

extension KWidget<T> on State<StatefulWidget> {
  bool isKeyboardVisible() {
    final insets = MediaQuery.of(this.context).viewInsets;
    return insets.bottom != 0;
  }

  bool isKeyboardHidden() => !isKeyboardVisible();
}
