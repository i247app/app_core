import 'dart:async';

enum KCallType {
  minimize,
  background,
  foreground,
  kill,
}

abstract class KCallControlStreamHelper {
  // ignore: close_sinks
  static StreamController<KCallType>? _cachedStreamController;

  static StreamController<KCallType> get _streamController {
    _cachedStreamController ??= StreamController.broadcast();
    return _cachedStreamController!;
  }

  static Stream<KCallType> get stream =>
      _streamController.stream.asBroadcastStream();

  static void broadcast(KCallType notif) => _streamController.add(notif);
}
