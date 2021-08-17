import 'package:app_core/model/kflash.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';

abstract class KFlashHelper {
  static final ValueNotifier<KFlash> flashController = ValueNotifier(KFlash());
  static final ConfettiController confettiController =
      ConfettiController(duration: Duration(seconds: 5));

  static int confettiCount = 50;

  static void rainConfetti({int? confettiCount, String? message}) {
    if (confettiCount != null) KFlashHelper.confettiCount = confettiCount;
    if (message != null) {
      flashController.value = KFlash()
        ..flashType = KFlash.TYPE_RAIN
        ..mediaType = KFlash.MEDIA_TEXT
        ..media = message;
    }
    confettiController.play();
  }

  static void stop() => confettiController.stop();

  static void rainEmoji([List<String>? emojis]) {
    flashController.value = KFlash()
      ..flashType = KFlash.TYPE_RAIN
      ..mediaType = KFlash.MEDIA_EMOJI
      ..media = emojis!.first;
  }

  static void banner(String text) => flashController.value = KFlash()
    ..flashType = KFlash.TYPE_BANNER
    ..mediaType = KFlash.MEDIA_TEXT
    ..media = text;
}
