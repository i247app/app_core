import 'package:app_core/app_core.dart';

abstract class KPasscodeHelper {
  static String? peer;
  static String? kCountryCode;
  static String? _fcmToken;
  static String? _voipToken;
  static KUserSession? kUserSession;
  static Future? Function(KSessionInitData)? _postSetupHook;
  static String? _sessionGenerationID;

  static storePasscode(String passcode) async {
    await KPrefHelper.put(KPrefHelper.PASSCODE, passcode);
  }

  static clearPasscode() async {
    await KPrefHelper.remove(KPrefHelper.PASSCODE);
  }

  static Future<bool> isPasscodeEnable() async {
    final passcode = await KPrefHelper.get(KPrefHelper.PASSCODE);
    return KStringHelper.isExist(passcode);
  }

  static Future<bool> checkPasscode(String _passcode) async {
    final passcode = await KPrefHelper.get(KPrefHelper.PASSCODE);
    return KStringHelper.isExist(passcode) &&
        KStringHelper.isExist(_passcode) &&
        passcode == _passcode;
  }
}
