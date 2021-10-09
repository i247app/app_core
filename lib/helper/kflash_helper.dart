import 'package:app_core/model/kflash.dart';
import 'package:flutter/foundation.dart';

abstract class KFlashHelper {
  static final ValueNotifier<KFlash> flashController = ValueNotifier(KFlash());

  static int confettiCount = 50;

  static KFlash get flash => flashController.value;

  static void rainConfetti({int? confettiCount, String? message}) {
    if (confettiCount != null) KFlashHelper.confettiCount = confettiCount;

    // Trigger banner overlay
    if (message != null) {
      flashController.value = KFlash()
        ..flashType = KFlash.TYPE_BANNER
        ..mediaType = KFlash.MEDIA_TEXT
        ..media = message;
    }

    // Trigger confetti overlay
    flashController.value = KFlash()
      ..flashType = KFlash.TYPE_RAIN
      ..mediaType = KFlash.MEDIA_CONFETTI;
  }

  static void rainEmoji([List<String>? emojis]) {
    flashController.value = KFlash()
      ..flashType = KFlash.TYPE_RAIN
      ..mediaType = KFlash.MEDIA_EMOJI
      ..media = emojis!.first;
  }

  static void banner(String text, {String mediaType = KFlash.MEDIA_TEXT}) =>
      flashController.value = KFlash()
        ..flashType = KFlash.TYPE_BANNER
        ..mediaType = mediaType
        ..media = text;

  static void hero(String heroImageURL) => banner(
        heroImageURL,
        mediaType: KFlash.MEDIA_HERO,
      );

  static void doFlash(KFlash flash) => flashController.value = flash;
}
