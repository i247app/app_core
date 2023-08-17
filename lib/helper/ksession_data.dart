import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/business_member.dart';
import 'package:app_core/model/kgig_nav.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class KSessionData {
  static String? kSessionToken;
  static String? kCountryCode;
  static String? _fcmToken;
  static String? _voipToken;
  static KUserSession? kUserSession;
  static Future? Function(KSessionInitData)? _postSetupHook;
  static String? _sessionGenerationID;

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
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        countryCode = placemarks.first.isoCountryCode;
      }
    } catch (ex) {}

    if (KStringHelper.isExist(countryCode)) {
      setCountryCode(countryCode);
    }
    return countryCode;
  }

  static Future<void> clearSessionToken() async {
    print("KSessionDate.clearSessionToken ${KSessionData.kSessionToken}");
    KSessionData.kSessionToken = null;
    print("KSessionDate.clearSessionToken remove ktoken from storage");
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

  static void setPostSetupHook(Future? Function(KSessionInitData) fn) =>
      _postSetupHook = fn;

  /// Setup the session data
  static Future setup(KSessionInitData data) async {
    try {
      getCountryCode();
    } catch (_) {}

    if (data.initSessionToken != null) {
      _sessionGenerationID ??= KUtil.buildRandomString(8);
      KSessionData.setSessionToken(data.initSessionToken);
      KSessionData.setUserSession(data.initUserSession);
      KPrefHelper.put(KPrefHelper.KTOKEN, data.initSessionToken);
      // PrefHelper.put("puid", data.initUserSession?.user?.puid);
      // PrefHelper.put("firstName", data.initUserSession?.user?.firstName);
      KPrefHelper.put(KPrefHelper.CACHED_USER, data.initUserSession?.user);

      // Allow clients (Chao & Schoolbird) to run code post SessionData setup
      await _postSetupHook?.call(data);
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

    _sessionGenerationID = null;

    // common
    KSessionData.setUserSession(null);
    return KSessionData.clearSessionToken();
  }

  static String? getSessionGeneration() => _sessionGenerationID;

  // // // // // user
  static KUserSession? getUserSession() => kUserSession;

  static void setUserSession(KUserSession? userSession) =>
      kUserSession = userSession;

  static KUserSession? get userSession => kUserSession;

  static KGigNav? get gigNav => kUserSession?.gigNav;

  static KUser? get me => userSession?.user;

  static bool get isTutor => userSession?.isTutorReady ?? false;

  static bool get isVerifiedTutor =>
      isTutor && KSessionData.tutor?.tutorStatus == Tutor.STATUS_ACTIVE;

  static bool get isBizReady => userSession?.isBizReady ?? false;

  static bool get isWorking => userSession?.tutor?.isWorking ?? false;

  static Tutor? get tutor => userSession?.tutor;

  static KAppNav? get appNav => userSession?.appCoreAppNav;

  // splashy home screen - effect base_screen/bottomNavBar and home_portal
  static bool get isSplashMode =>
      (userSession?.appCoreAppNav?.splashMode ?? KAppNav.ON) == KAppNav.ON;

  static bool get isGuest => false; // userSession == null;

  // // // // // app
  static List<BusinessMember>? get businessMembers =>
      getUserSession()?.businessMembers;

  static Business? get activeBusiness => getUserSession()?.business;

  static Store? get activeStore => (activeBusiness?.stores ?? []).isNotEmpty
      ? activeBusiness!.stores!.first
      : null; // should be only one??

  static String? get activeTokenName => activeBusiness?.tokenName;

  static String? get activeBUID => activeBusiness?.buid;

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
