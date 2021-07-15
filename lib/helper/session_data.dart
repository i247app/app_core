// import 'package:app_core/helper/call_kit_helper.dart';
// import 'package:app_core/helper/fcm_helper.dart';
import 'package:app_core/helper/host_config.dart';
// import 'package:app_core/helper/motd_helper.dart';
import 'package:app_core/helper/pref_helper.dart';
import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/model/app_nav.dart';
import 'package:app_core/model/host_info.dart';
import 'package:app_core/model/user.dart';
import 'package:app_core/model/user_session.dart';
import 'package:app_core/header/session_init_data.dart';

abstract class AppCoreSessionData {
  static String? _sessionToken;
  static String? _fcmToken;
  static String? _voipToken;
  static AppCoreUserSession? _userSession;

  // // // // // system
  static bool get hasActiveSession =>
      AppCoreStringHelper.isExist(getSessionToken() ?? "");

  static String? getSessionToken() => _sessionToken;

  static void setSessionToken(String? sessionToken) {
    if (AppCoreStringHelper.isExist(sessionToken ?? "")) {
      AppCoreSessionData._sessionToken = sessionToken;
      AppCorePrefHelper.put(AppCorePrefHelper.KTOKEN, sessionToken);
    }
  }

  static void clearSessionToken() {
    AppCoreSessionData._sessionToken = null;
    AppCorePrefHelper.remove(AppCorePrefHelper.KTOKEN);
  }

  // static Future<String> getFCMToken() async {
  //   FCMHelper.getPushToken().then((v) => _fcmToken = v);
  //   if (_fcmToken == null) _fcmToken = await FCMHelper.getPushToken();
  //   return _fcmToken!;
  // }
  //
  // static Future<String> getVoipToken() async {
  //   CallKitHelper.instance.getVoIPToken().then((v) => _voipToken = v);
  //   if (_voipToken == null)
  //     _voipToken = await CallKitHelper.instance.getVoIPToken();
  //   return _voipToken ?? "";
  // }

  // TODO = think about port hard coded to 8086
  static AppCoreHostInfo get webRTCHostInfo =>
      userSession?.appCoreHostData?.appCoreWebRtcHostInfo ??
          AppCoreHostConfig.hostInfo.copyWith(port: 8086);

  /// Setup the session data
  static void setup(AppCoreSessionInitData data) {
    if (data.initSessionToken != null) {
      AppCoreSessionData.setSessionToken(data.initSessionToken);
      AppCoreSessionData.setUserSession(data.initUserSession);
      AppCorePrefHelper.put(AppCorePrefHelper.KTOKEN, data.initSessionToken);
      // PrefHelper.put("puid", data.initUserSession?.user?.puid);
      // PrefHelper.put("firstName", data.initUserSession?.user?.firstName);
      AppCorePrefHelper.put(AppCorePrefHelper.CACHED_USER, data.initUserSession?.appCoreUser);
    }
  }

  /// Reload the session data
  // static Future reload() async {
  //   final response = await ServerHandler.resumeSession(
  //       SessionData.getSessionToken(), "SessionData.reload");
  //   SessionData.setup(response);
  // }

  /// Clear the session data
  static Future wipeSession() {
    // SessionData._carts = {};
    // MOTDHelper.reset();
    // HomePortal.homeViewCount = 0; // determine if motd appears

    // common
    AppCoreSessionData.clearSessionToken();
    AppCoreSessionData.setUserSession(null);
    return AppCorePrefHelper.remove(AppCorePrefHelper.KTOKEN);
  }

  // // // // // user
  static AppCoreUserSession? getUserSession() => _userSession;

  static void setUserSession(AppCoreUserSession? userSession) =>
      userSession == null ? null : AppCoreSessionData._userSession = userSession;

  static AppCoreUserSession? get userSession => _userSession;

  static AppCoreUser? get me => userSession?.appCoreUser;

  static AppCoreAppNav? get appNav => userSession?.appCoreAppNav;

  // splashy home screen - effect base_screen/bottomNavBar and home_portal
  static bool get isSplashMode =>
      (userSession?.appCoreAppNav?.splashMode ?? AppCoreAppNavStatus.ON) == AppCoreAppNavStatus.ON;

  static bool get isOnline => userSession?.isOnlineMode ?? false;

  static bool get isGuest => _userSession == null;
}
