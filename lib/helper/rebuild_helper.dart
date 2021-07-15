import 'dart:async';

enum AppCoreRebuildHelperSignal { rebuild }

abstract class AppCoreRebuildHelper {
  static final StreamController<AppCoreRebuildHelperSignal> _streamController =
      StreamController.broadcast();

  static Stream<AppCoreRebuildHelperSignal> get stream =>
      _streamController.stream.asBroadcastStream();

  static void forceRebuild() =>
      _streamController.add(AppCoreRebuildHelperSignal.rebuild);
}
