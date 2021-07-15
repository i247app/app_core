import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/model/app_nav.dart';
import 'package:app_core/model/system_host_data.dart';
import 'package:app_core/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
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

  @JsonKey(name: KTOKEN)
  String? ktoken;

  @JsonKey(name: PUID)
  String? puid;

  @JsonKey(name: ONLINE_MODE)
  String? onlineMode;

  @JsonKey(name: GOOGLE_MAP_API_KEY)
  String? googleMapAPIKey;

  @JsonKey(name: APP_NAV)
  AppCoreAppNav? appNav = AppCoreAppNav();

  @JsonKey(name: USER)
  AppCoreUser? user;

  @JsonKey(name: HOST_DATA)
  AppCoreSystemHostData? hostData;

  // Methods
  @JsonKey(ignore: true)
  bool get isOnlineMode => AppCoreStringHelper.parseBoolean(this.onlineMode);

  // JSON
  AppCoreUserSession();
}
