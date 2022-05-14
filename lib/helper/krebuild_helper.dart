import 'package:flutter/cupertino.dart';

enum KRebuildHelperSignal { rebuild }

abstract class KRebuildHelper {
  static final ChangeNotifier notifier = ChangeNotifier();

  static void forceRebuild() {
    notifier.notifyListeners();
    imageCache.clear(); // Clear the image cache
  }
}
