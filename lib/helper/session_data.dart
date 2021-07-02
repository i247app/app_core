import 'package:app_core/helper/pref_helper.dart';
import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/model/host_info.dart';
import 'package:app_core/model/user.dart';
import 'package:app_core/model/user_session.dart';

import 'host_config.dart';

abstract class SessionData {
  static String? _sessionToken;
  static AppCoreUserSession? _userSession;

  // // // // // system
  static bool get hasActiveSession =>
      StringHelper.isExist(getSessionToken() ?? "");

  static String? getSessionToken() => _sessionToken;

  static void setSessionToken(String? sessionToken) {
    if (StringHelper.isExist(sessionToken ?? "")) {
      SessionData._sessionToken = sessionToken;
      PrefHelper.put(PrefHelper.KTOKEN, sessionToken);
    }
  }

  static void clearSessionToken() {
    SessionData._sessionToken = null;
    PrefHelper.remove(PrefHelper.KTOKEN);
  }

  // // // // // user
  static AppCoreUserSession? get userSession => _userSession;

  static AppCoreUser? get me => userSession?.user;

  static HostInfo get webRTCHostInfo =>
      userSession?.hostData?.webRtcHostInfo ??
          HostConfig.hostInfo.copyWith(port: 8086);
}
