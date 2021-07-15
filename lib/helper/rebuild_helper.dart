import 'dart:async';

enum KRebuildHelperSignal { rebuild }

abstract class KRebuildHelper {
  static final StreamController<KRebuildHelperSignal> _streamController =
      StreamController.broadcast();

  static Stream<KRebuildHelperSignal> get stream =>
      _streamController.stream.asBroadcastStream();

  static void forceRebuild() =>
      _streamController.add(KRebuildHelperSignal.rebuild);
}
