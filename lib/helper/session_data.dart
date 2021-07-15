import 'package:app_core/helper/host_config.dart';
import 'package:app_core/helper/pref_helper.dart';
import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/model/app_nav.dart';
import 'package:app_core/model/host_info.dart';
import 'package:app_core/model/user.dart';
import 'package:app_core/model/user_session.dart';
import 'package:app_core/header/session_init_data.dart';

abstract class KSessionData {
  static String? _sessionToken;
  static String? _fcmToken;
  static String? _voipToken;
  static KUserSession? _userSession;

  // // // // // system
  static bool get hasActiveSession =>
      KStringHelper.isExist(getSessionToken() ?? "");

  static String? getSessionToken() => _sessionToken;

  static void setSessionToken(String? sessionToken) {
    if (KStringHelper.isExist(sessionToken ?? "")) {
      KSessionData._sessionToken = sessionToken;
      KPrefHelper.put(KPrefHelper.KTOKEN, sessionToken);
    }
  }

  static void clearSessionToken() {
    KSessionData._sessionToken = null;
    KPrefHelper.remove(KPrefHelper.KTOKEN);
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
  static KHostInfo get webRTCHostInfo =>
      userSession?.appCoreHostData?.appCoreWebRtcHostInfo ??
      KHostConfig.hostInfo.copyWith(port: 8086);

  /// Setup the session data
  static void setup(AppCoreSessionInitData data) {
    if (data.initSessionToken != null) {
      KSessionData.setSessionToken(data.initSessionToken);
      KSessionData.setUserSession(data.initUserSession);
      KPrefHelper.put(KPrefHelper.KTOKEN, data.initSessionToken);
      // PrefHelper.put("puid", data.initUserSession?.user?.puid);
      // PrefHelper.put("firstName", data.initUserSession?.user?.firstName);
      KPrefHelper.put(
          KPrefHelper.CACHED_USER, data.initUserSession?.appCoreUser);
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
    KSessionData.clearSessionToken();
    KSessionData.setUserSession(null);
    return KPrefHelper.remove(KPrefHelper.KTOKEN);
  }

  // // // // // user
  static KUserSession? getUserSession() => _userSession;

  static void setUserSession(KUserSession? userSession) =>
      userSession == null ? null : KSessionData._userSession = userSession;

  static KUserSession? get userSession => _userSession;

  static KUser? get me => userSession?.appCoreUser;

  static KAppNav? get appNav => userSession?.appCoreAppNav;

  // splashy home screen - effect base_screen/bottomNavBar and home_portal
  static bool get isSplashMode =>
      (userSession?.appCoreAppNav?.splashMode ?? KAppNavStatus.ON) ==
      KAppNavStatus.ON;

  static bool get isOnline => userSession?.isOnlineMode ?? false;

  static bool get isGuest => _userSession == null;
}
