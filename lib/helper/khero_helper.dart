import 'package:app_core/model/khero.dart';

abstract class KHeroHelper {
  /// Check if the hero is an egg
  static bool isEgg(KHero hero) {
    try {
      return hero.hatchDate == null;
    } catch (_) {
      return false;
    }
  }

  /// Check if the hero is eligible to hatch
  static bool isHatchable(KHero hero) {
    try {
      return hero.eggDate!.add(hero.eggDuration!).isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }
}
