import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

abstract class KBiometricHelper {
  static final LocalAuthentication localAuth = LocalAuthentication();

  static Future<bool> isAvailable() async {
    final canCheckBiometrics = await localAuth.canCheckBiometrics;
    final hasAvailableMethods =
    await localAuth.getAvailableBiometrics().then((r) => r.isNotEmpty);
    return canCheckBiometrics && hasAvailableMethods;
  }

  static Future<bool> isFaceIdAvailable() async {
    final result = await localAuth.getAvailableBiometrics();
    return result.contains(BiometricType.face);
  }

  static Future<bool> isFingerprintAvailable() async {
    final result = await localAuth.getAvailableBiometrics();
    if (Platform.isAndroid) {
      return result.contains(BiometricType.fingerprint) ||
          result.contains(BiometricType.strong);
    }
    return result.contains(BiometricType.fingerprint);
  }

  static Future<bool> authenticate(String reason,
      {MethodChannel? channel}) async {
    return localAuth.authenticate(
      localizedReason: reason,
      options: AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
    // if (Platform.isAndroid) {
    //   try {
    //     final response =
    //         await KPluginHelper.biometricAuth(reason, channel: channel);
    //     if (response == null)
    //       return localAuth.authenticate(
    //         localizedReason: reason,
    //         options: AuthenticationOptions(
    //           biometricOnly: true,
    //         ),
    //       );
    //     else
    //       return response;
    //   } catch (e) {
    //     return false;
    //   }
    // } else {
    //   return localAuth.authenticate(
    //     localizedReason: reason,
    //     options: AuthenticationOptions(
    //       biometricOnly: true,
    //     ),
    //   );
    // }
  }
}
