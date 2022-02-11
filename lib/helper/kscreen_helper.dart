import 'package:app_core/app_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

abstract class KScreenHelper {
  static bool get isTablet =>
      KTabletDetector.isTablet(MediaQuery.of(kNavigatorKey.currentContext!));

  /// Set default allowed device orientations
  static void resetOrientation(BuildContext context) async {
    // Always support portrait mode AT LEAST
    List<DeviceOrientation> orientations = [DeviceOrientation.portraitUp];

    // Support landscape if a tablet
    try {
      if (await KUtil.isTabletDevice(context)) {
        print("ScreenHelper THIS IS A TABLET");
        orientations.addAll([
          // DeviceOrientation.landscapeLeft,
          // DeviceOrientation.landscapeRight,
        ]);
      } else
        print("ScreenHelper NOT TABLET");
    } catch (e) {}

    SystemChrome.setPreferredOrientations(orientations);
  }

  static void landscapeOrientation(BuildContext context) async {
    // Always support portrait mode AT LEAST
    List<DeviceOrientation> orientations = [DeviceOrientation.landscapeLeft];

    SystemChrome.setPreferredOrientations(orientations);
  }
}
