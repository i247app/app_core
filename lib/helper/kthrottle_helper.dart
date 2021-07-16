import 'package:flutter/cupertino.dart';

abstract class KThrottleHelper {
  static const Duration DEFAULT_DURATION = Duration(milliseconds: 500);
  static const String DEFAULT_THROTTLE_ID = "_default";

  static final Map<dynamic, DateTime> _throttleHistory = {};

  /// Restrict how often a function can be called
  static VoidCallback throttle(
    Function f, {
    Duration duration = DEFAULT_DURATION,
    dynamic throttleID = DEFAULT_THROTTLE_ID,
  }) =>
      () {
        DateTime now = DateTime.now();
        DateTime? lastTime = _throttleHistory[throttleID];

        bool isAllowed =
            lastTime == null || lastTime.add(duration).isBefore(now);

        if (isAllowed) {
          _throttleHistory[throttleID] = now;
          f();
          // perhaps after executing, clear the map or the throttle id entry
        } else
          print("#THROTTLED");
      };
}
