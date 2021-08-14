import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';

import 'kutil.dart';

abstract class KConfettiHelper {
  static final ConfettiController controller =
      ConfettiController(duration: Duration(seconds: 5));
  static final ValueNotifier<String> emojiController = ValueNotifier("");

  static int confettiCount = 50;
  static String confettiMessage = "";
  static String emoji = "🤤";

  static void play({int? confettiCount, String? message}) {
    if (confettiCount != null) KConfettiHelper.confettiCount = confettiCount;
    if (message != null) KConfettiHelper.confettiMessage = message;
    controller.play();
  }

  static void stop() => controller.stop();

  static void playEmoji([String? _emoji]) {
    emoji = _emoji ?? "🤤";
    emojiController.value = KUtil.buildRandomString(8);
  }
}
