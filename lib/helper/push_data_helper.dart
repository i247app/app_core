import 'dart:async';

import 'package:app_core/model/push_data.dart';

abstract class KPushDataHelper {
  static final StreamController<KPushData> _streamController =
      StreamController.broadcast();

  static Stream<KPushData> get stream =>
      _streamController.stream.asBroadcastStream();

  static void broadcast(KPushData pushData) => _streamController.add(pushData);
}
