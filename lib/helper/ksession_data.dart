import 'package:app_core/header/ksession_init_data.dart';
import 'package:app_core/helper/kcall_kit_helper.dart';
import 'package:app_core/helper/kfcm_helper.dart';
import 'package:app_core/helper/khost_config.dart';
import 'package:app_core/helper/klocation_helper.dart';
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
import 'package:app_core/model/store.dart';
import 'package:app_core/model/tutor.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class KSessionData {
  static String? kSessionToken;
  static String? kCountryCode;
  static String? _fcmToken;
  static String? _voipToken;
  static KUserSession? kUserSession;
  static void Function(KSessionInitData)? _postSetupHook;

  // // // // // system
  static bool get hasActiveSession => getSessionToken() != null;

  static String? getSessionToken() => kSessionToken;

  static void setSessionToken(String? sessionToken) {
    if (KStringHelper.isExist(sessionToken ?? "")) {
      KSessionData.kSessionToken = sessionToken;
      KPrefHelper.put(KPrefHelper.KTOKEN, sessionToken);
    }
  }

  static void setCountryCode(String? countryCode) {
    KSessionData.kCountryCode = countryCode;
  }

  static Future<String?> getCountryCode() async {
    if (KStringHelper.isExist(kCountryCode)) {
      return kCountryCode;
    }
    String? countryCode;
    try {
      Position? position = KLocationHelper.cachedPosition;
      if (position != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        countryCode = placemarks.first.isoCountryCode;
      }
    } catch(ex) {}

    if (KStringHelper.isExist(countryCode)) {
      setCountryCode(countryCode);
    }
    return countryCode;
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
    if (_voipToken == null) {
      print("KSessionData - Fetching VOIP token...");
      _voipToken = (await KCallKitHelper.instance.getVoIPToken()) ?? "";
    }
    return _voipToken ?? "";
  }

  // TODO = think about port hard coded to 8086
  static KHostInfo get webRTCHostInfo =>
      userSession?.hostData?.webRtcHostInfo ??
      KHostConfig.hostInfo
          .copyWith(port: KHostConfig.isReleaseMode ? 9443 : 9090);

  static void setPostSetupHook(void Function(KSessionInitData) fn) =>
      _postSetupHook = fn;

  /// Setup the session data
  static void setup(KSessionInitData data) {
    try {
      getCountryCode();
    } catch(ex) {}
    if (data.initSessionToken != null) {
      KSessionData.setSessionToken(data.initSessionToken);
      KSessionData.setUserSession(data.initUserSession);
      KPrefHelper.put(KPrefHelper.KTOKEN, data.initSessionToken);
      // PrefHelper.put("puid", data.initUserSession?.user?.puid);
      // PrefHelper.put("firstName", data.initUserSession?.user?.firstName);
      KPrefHelper.put(KPrefHelper.CACHED_USER, data.initUserSession?.user);

      // Allow clients (Chao & Schoolbird) to run code post SessionData setup
      _postSetupHook?.call(data);
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

  static bool get isBizReady => userSession?.isBizReady ?? false;

  static bool get isWorking => userSession?.tutor?.isWorking ?? false;

  static Tutor? get tutor => userSession?.tutor;

  static KAppNav? get appNav => userSession?.appCoreAppNav;

  // splashy home screen - effect base_screen/bottomNavBar and home_portal
  static bool get isSplashMode =>
      (userSession?.appCoreAppNav?.splashMode ?? KAppNav.ON) == KAppNav.ON;

  static bool get isGuest => userSession == null;

  // // // // // app
  static List<BusinessMember>? get businessMembers =>
      getUserSession()?.businessMembers;

  static Business? get activeBusiness => getUserSession()?.business;

  static Store? get activeStore => (activeBusiness?.stores ?? []).isNotEmpty
      ? activeBusiness!.stores!.first
      : null; // should be only one??

  static String get activeTokenName => activeBusiness?.tokenName ?? "";

  static String get activeBUID => activeBusiness?.buid ?? "";

  static BusinessMember? get activeMember => userSession?.getActiveMember();

  static String? get activeStoreID => activeStore?.storeID;

  static bool get isDomainAdmin => userSession?.isDomainAdminReady ?? false;
  static bool get isAdmin => userSession?.isAdminReady ?? false;
  static bool get isSuperAdmin => userSession?.isSuperAdmin ?? false;

  static bool get isBizAdmin =>
      isBusinessMode && activeMember?.role == BusinessMember.ROLE_ADMIN;

  static bool get isGlobalAdmin =>
      isBusinessMode && activeMember?.buid == "808";

  static bool get isBusinessMode => activeBusiness != null;
}
