abstract class KThrottleHelper {
  static const Duration DEFAULT_DURATION = Duration(milliseconds: 500);
  static const String DEFAULT_THROTTLE_ID = "_default";

  static final Map<dynamic, DateTime> _throttleHistory = {};

  /// Restrict how often a function can be called
  static dynamic Function() throttle(
    dynamic Function() f, {
    Duration duration = DEFAULT_DURATION,
    dynamic throttleID = DEFAULT_THROTTLE_ID,
  }) =>
      () {
        final now = DateTime.now();
        final lastTime = _throttleHistory[throttleID];
        final isAllowed =
            lastTime == null || lastTime.add(duration).isBefore(now);

        if (isAllowed) {
          _throttleHistory[throttleID] = now;
          return f();
          // perhaps after executing, clear the map or the throttle id entry
        } else {
          print("#THROTTLED");
          return null;
        }
      };
}
