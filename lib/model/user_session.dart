import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/model/system_host_data.dart';
import 'package:app_core/model/app_core_user.dart';

class AppCoreUserSession {
  static const String KTOKEN = "ktoken";
  static const String PUID = "puid";
  static const String USER_MODE = "userMode";
  static const String ONLINE_MODE = "onlineMode";
  static const String GOOGLE_MAP_API_KEY = "googleMapAPIKey";
  static const String APP_NAV = "appNav";
  static const String USER = "user";
  static const String TUTOR = "tutor";
  static const String HOST_DATA = "hostData";
  static const String BUSINESS = "business";
  static const String BUSINESS_MEMBERS = "businessMembers";

  static const String MODE_USER = "USER";
  static const String MODE_TUTOR = "TUTOR";

  String? ktoken;

  String? puid;

  String? onlineMode;

  String? googleMapAPIKey;

  AppCoreUser? user;

  // AppNav? appNav = AppNav();
  //
  // SystemHostData? hostData;

  // @JsonKey(name: HOST_DATA)
  SystemHostData? hostData;

  // Methods
  bool get isOnlineMode => StringHelper.parseBoolean(this.onlineMode);

  // JSON
  AppCoreUserSession();
}
