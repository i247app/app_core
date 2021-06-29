import 'dart:async';

enum RebuildHelperSignal { rebuild }

abstract class RebuildHelper {
  static final StreamController<RebuildHelperSignal> _streamController =
      StreamController.broadcast();

  static Stream<RebuildHelperSignal> get stream =>
      _streamController.stream.asBroadcastStream();

  static void forceRebuild() =>
      _streamController.add(RebuildHelperSignal.rebuild);
}
