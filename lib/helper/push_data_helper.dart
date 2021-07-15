import 'dart:async';

import 'package:app_core/model/push_data.dart';

abstract class AppCorePushDataHelper {
  static final StreamController<AppCorePushData> _streamController =
      StreamController.broadcast();

  static Stream<AppCorePushData> get stream =>
      _streamController.stream.asBroadcastStream();

  static void broadcast(AppCorePushData pushData) => _streamController.add(pushData);
}
