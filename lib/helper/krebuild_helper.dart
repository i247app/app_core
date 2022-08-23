import 'package:flutter/cupertino.dart';

enum KRebuildHelperSignal { rebuild }

abstract class KRebuildHelper {
  static final ChangeNotifier notifier = ChangeNotifier();
  static final ChangeNotifier hardReloadNotifier = ChangeNotifier();

  static void forceRebuild() {
    notifier.notifyListeners();
    imageCache.clear(); // Clear the image cache
  }

  static void forceHardReload() {
    hardReloadNotifier.notifyListeners();
    imageCache.clear(); // Clear the image cache
  }
}
