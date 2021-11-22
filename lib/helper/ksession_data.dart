import 'package:app_core/helper/kamp_helper.dart';
import 'package:app_core/helper/kcall_kit_helper.dart';
import 'package:app_core/helper/kfcm_helper.dart';
import 'package:app_core/helper/khost_config.dart';
import 'package:app_core/helper/kpref_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/model/business.dart';
import 'package:app_core/model/business_member.dart';
import 'package:app_core/model/kapp_nav.dart';
import 'package:app_core/model/kgig_nav.dart';
import 'package:app_core/model/khost_info.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/model/kuser_session.dart';
import 'package:app_core/header/ksession_init_data.dart';
import 'package:app_core/model/store.dart';
import 'package:app_core/model/tutor.dart';

abstract class KSessionData {
  static String? kSessionToken;
  static String? _fcmToken;
  static String? _voipToken;
  static KUserSession? kUserSession;
  static Map<String, AMPData> _carts = {};

  // // // // // system
  static bool get hasActiveSession => getSessionToken() != null;

  static String? getSessionToken() => kSessionToken;

  static void setSessionToken(String? sessionToken) {
    if (KStringHelper.isExist(sessionToken ?? "")) {
      KSessionData.kSessionToken = sessionToken;
      KPrefHelper.put(KPrefHelper.KTOKEN, sessionToken);
    }
  }

  static Future<void> clearSessionToken() async {
    KSessionData.kSessionToken = null;
    await KPrefHelper.remove(KPrefHelper.KTOKEN);
  }

  static Future<String> getFCMToken() async {
    KFCMHelper.getPushToken().then((v) => _fcmToken = v);
    if (_fcmToken == null) _fcmToken = await KFCMHelper.getPushToken();
    return _fcmToken!;
  }

  static Future<String> getVoipToken() async {
    KCallKitHelper.instance.getVoIPToken().then((v) => _voipToken = v);
    if (_voipToken == null)
      _voipToken = await KCallKitHelper.instance.getVoIPToken();
    return _voipToken ?? "";
  }

  // TODO = think about port hard coded to 8086
  static KHostInfo get webRTCHostInfo =>
      userSession?.hostData?.webRtcHostInfo ??
      KHostConfig.hostInfo
          .copyWith(port: KHostConfig.isReleaseMode ? 9443 : 9090);

  /// Setup the session data
  static void setup(KSessionInitData data) {
    if (data.initSessionToken != null) {
      KSessionData.setSessionToken(data.initSessionToken);
      KSessionData.setUserSession(data.initUserSession);
      KPrefHelper.put(KPrefHelper.KTOKEN, data.initSessionToken);
      // PrefHelper.put("puid", data.initUserSession?.user?.puid);
      // PrefHelper.put("firstName", data.initUserSession?.user?.firstName);
      KPrefHelper.put(KPrefHelper.CACHED_USER, data.initUserSession?.user);
    }
  }

  /// Reload the session data
  // static Future reload() async {
  //   final response = await ServerHandler.resumeSession(
  //       SessionData.getSessionToken(), "SessionData.reload");
  //   SessionData.setup(response);
  // }

  /// Reload the session data
  static Future reload() async {
    final response = await KServerHandler.resumeSession(
        KSessionData.getSessionToken(), "SessionData.reload");
    KSessionData.setup(response);
  }

  /// Clear the session data
  static Future wipeSession() {
    // SessionData._carts = {};
    // MOTDHelper.reset();
    // HomePortal.homeViewCount = 0; // determine if motd appears

    // common
    KSessionData.setUserSession(null);
    return KSessionData.clearSessionToken();
  }

  // // // // // user
  static KUserSession? getUserSession() => kUserSession;

  static void setUserSession(KUserSession? userSession) =>
      kUserSession = userSession;

  static KUserSession? get userSession => kUserSession;

  static KGigNav? get gigNav => kUserSession?.gigNav;

  static KUser? get me => userSession?.user;

  static bool get isApprovedTutor => userSession?.isTutorReady ?? false;

  static bool get isTutorOnline => userSession?.tutor?.isOnline ?? false;

  static Tutor? get tutor => userSession?.tutor;

  static KAppNav? get appNav => userSession?.appCoreAppNav;

  // splashy home screen - effect base_screen/bottomNavBar and home_portal
  static bool get isSplashMode =>
      (userSession?.appCoreAppNav?.splashMode ?? KAppNav.ON) == KAppNav.ON;

  static bool get isGuest => userSession == null;

  // // // // // app
  static Map<String, AMPData> get carts => _carts;

  static void setCart(AMPData ampData) {
    if (ampData.key != null) carts[ampData.key!] = ampData;
  }

  static void removeCart(AMPData ampData) {
    try {
      carts.removeWhere((k, v) => k == ampData.key);
    } catch (e) {}
  }

  static List<BusinessMember>? get businessMembers =>
      getUserSession()?.businessMembers;

  static Business? get activeBusiness =>
      getUserSession() != null ? getUserSession()!.business : null;

  static Store? get activeStore =>
      activeBusiness != null && activeBusiness!.stores != null
          ? activeBusiness!.stores!.first
          : null; // should be only one??

  static String get activeTokenName =>
      activeBusiness != null ? activeBusiness!.tokenName ?? "" : "";

  static String get activeBUID =>
      activeBusiness != null ? activeBusiness!.buid ?? "" : "";

  static BusinessMember? get activeMember =>
      userSession != null ? userSession!.getActiveMember() : null;

  static String get activeStoreID =>
      activeStore != null ? activeStore!.storeID ?? "" : "";

  static bool get isAdmin => userSession?.isAdminReady ?? false;

  static bool get isBizAdmin =>
      isBusinessMode &&
      activeMember != null &&
      activeMember!.role == BusinessMember.ROLE_ADMIN;

  static bool get isGlobalAdmin =>
      // Util.isDebug || // remove this when done testing
      (isBusinessMode && activeMember != null && activeMember!.buid == "808");

  static bool get isBusinessMode => activeBusiness != null;
}
