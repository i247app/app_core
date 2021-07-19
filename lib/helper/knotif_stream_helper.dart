import 'dart:async';

import 'package:app_core/model/kfull_notification.dart';

abstract class KNotifStreamHelper {
  // ignore: close_sinks
  static StreamController<KFullNotification>? _cachedStreamController;

  static StreamController<KFullNotification> get _streamController {
    _cachedStreamController ??= StreamController.broadcast();
    return _cachedStreamController!;
  }

  static Stream<KFullNotification> get stream =>
      _streamController.stream.asBroadcastStream();

  static void broadcast(KFullNotification notif) =>
      _streamController.add(notif);
}
