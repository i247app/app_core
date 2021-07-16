import 'dart:io';

import 'package:local_auth/local_auth.dart';
import 'package:app_core/helper/kplugin_helper.dart';

abstract class KBiometricHelper {
  static final LocalAuthentication localAuth = LocalAuthentication();

  static Future<bool> isAvailable() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    final hasAvailableMethods = await localAuth.getAvailableBiometrics().then((r) => r.isNotEmpty);
    return canCheckBiometrics && hasAvailableMethods;
  }

  static Future<bool> authenticate(String reason) async {
    if (Platform.isAndroid) {
      try {
        final response = await KPluginHelper.biometricAuth(reason);
        if (response == null)
          return localAuth.authenticate(
            localizedReason: reason,
            biometricOnly: true,
          );
        else
          return response;
      } catch (e) {
        return false;
      }
    } else {
      return localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
    }
  }
}
