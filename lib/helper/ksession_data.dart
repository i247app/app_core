import 'package:app_core/helper/khost_config.dart';
import 'package:app_core/helper/kpref_helper.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/model/kapp_nav.dart';
import 'package:app_core/model/khost_info.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/model/kuser_session.dart';
import 'package:app_core/header/ksession_init_data.dart';

abstract class KSessionData {
  static String? kSessionToken;
  static String? _fcmToken;
  static String? _voipToken;
  static KUserSession? kUserSession;

  // // // // // system
  static bool get hasActiveSession =>
      KStringHelper.isExist(getSessionToken() ?? "");

  static String? getSessionToken() => kSessionToken;

  static void setSessionToken(String? sessionToken) {
    if (KStringHelper.isExist(sessionToken ?? "")) {
      KSessionData.kSessionToken = sessionToken;
      KPrefHelper.put(KPrefHelper.KTOKEN, sessionToken);
    }
  }

  static void clearSessionToken() {
    KSessionData.kSessionToken = null;
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
  static void setup(KSessionInitData data) {
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
  static KUserSession? getUserSession() => kUserSession;

  static void setUserSession(KUserSession? userSession) =>
      userSession == null ? null : kUserSession = userSession;

  static KUserSession? get userSession => kUserSession;

  static KUser? get me => userSession?.appCoreUser;

  static KAppNav? get appNav => userSession?.appCoreAppNav;

  // splashy home screen - effect base_screen/bottomNavBar and home_portal
  static bool get isSplashMode =>
      (userSession?.appCoreAppNav?.splashMode ?? KAppNavStatus.ON) ==
      KAppNavStatus.ON;

  static bool get isOnline => userSession?.isOnlineMode ?? false;

  static bool get isGuest => userSession == null;
}
