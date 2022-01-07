import 'dart:async';

import 'package:app_core/ui/ui.dart';

abstract class KCallStreamHelper {
  // ignore: close_sinks
  static StreamController<KVOIPCall>? _cachedStreamController;

  static StreamController<KVOIPCall> get _streamController {
    _cachedStreamController ??= StreamController.broadcast();
    return _cachedStreamController!;
  }

  static Stream<KVOIPCall> get stream =>
      _streamController.stream.asBroadcastStream();

  static void broadcast(KVOIPCall notif) => _streamController.add(notif);
}
