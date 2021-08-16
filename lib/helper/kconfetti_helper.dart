import 'package:app_core/helper/kutil.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';

abstract class KConfettiHelper {
  static final ConfettiController controller =
      ConfettiController(duration: Duration(seconds: 5));
  static final ValueNotifier<String> emojiController = ValueNotifier("");

  static int confettiCount = 50;
  static String confettiMessage = "";
  static List<String> displayEmojis = ["🎈", "🎉"];

  static void play({int? confettiCount, String? message}) {
    if (confettiCount != null) KConfettiHelper.confettiCount = confettiCount;
    if (message != null) KConfettiHelper.confettiMessage = message;
    controller.play();
  }

  static void stop() => controller.stop();

  static void playEmoji([List<String>? emojis]) {
    if (emojis != null) KConfettiHelper.displayEmojis = emojis;
    emojiController.value = KUtil.buildRandomString(8);
  }
}
