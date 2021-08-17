import 'package:app_core/helper/kutil.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';

abstract class KFlashHelper {
  static final ConfettiController controller =
      ConfettiController(duration: Duration(seconds: 5));
  static final ValueNotifier<String> emojiController = ValueNotifier("");

  static int confettiCount = 50;
  static String confettiMessage = "";
  static List<String> displayEmojis = ["🎈", "🎉"];

  static void rainConfetti({int? confettiCount, String? message}) {
    if (confettiCount != null) KFlashHelper.confettiCount = confettiCount;
    if (message != null) KFlashHelper.confettiMessage = message;
    controller.play();
  }

  static void stop() => controller.stop();

  static void rainEmoji([List<String>? emojis]) {
    if (emojis != null) KFlashHelper.displayEmojis = emojis;
    emojiController.value = KUtil.buildRandomString(8);
  }

  static void banner(String text) => rainEmoji([text]);
}
