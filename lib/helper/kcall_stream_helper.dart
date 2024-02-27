import 'dart:async';

import 'package:app_core/ui/peer/kpeer_voip_call.dart';

abstract class KCallStreamHelper {
  // ignore: close_sinks
  static StreamController<KPeerVoipCall?>? _cachedStreamController;

  static StreamController<KPeerVoipCall?> get _streamController {
    _cachedStreamController ??= StreamController.broadcast();
    return _cachedStreamController!;
  }

  static Stream<KPeerVoipCall?> get stream =>
      _streamController.stream.asBroadcastStream();

  static void broadcast(KPeerVoipCall? notif) => _streamController.add(notif);
}
