import 'package:app_core/model/business.dart';
import 'package:app_core/model/business_member.dart';
import 'package:app_core/model/kapp_nav.dart';
import 'package:app_core/model/kgig_nav.dart';
import 'package:app_core/model/ksystem_host_data.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:app_core/model/tutor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kuser_session.g.dart';

@JsonSerializable()
class KUserSession {
  static const String KTOKEN = "ktoken";
  static const String PUID = "puid";
  static const String USER_MODE = "userMode";
  static const String ONLINE_MODE = "onlineMode";
  static const String GOOGLE_MAP_API_KEY = "googleMapAPIKey";
  static const String APP_NAV = "appNav";
  static const String GIG_NAV = "gigNav";
  static const String USER = "user";
  static const String TUTOR = "tutor";
  static const String HOST_DATA = "hostData";
  static const String IS_TUTOR_READY = "isTutorReady";
  static const String IS_BIZ_READY = "isBizReady";
  static const String IS_CUSUP_READY = "isCUSUPReady";
  static const String IS_DOMAIN_ADMIN_READY = "isDomainAdminReady";
  static const String IS_ADMIN_READY = "isAdminReady";
  static const String IS_SUPER_ADMIN = "isSuperAdmin";
  static const String BUSINESS = "business";
  static const String BUSINESS_MEMBERS = "businessMembers";

  @JsonKey(name: KTOKEN)
  String? ktoken;

  @JsonKey(name: PUID)
  String? puid;

  @JsonKey(name: GOOGLE_MAP_API_KEY)
  String? googleMapAPIKey;

  @JsonKey(name: APP_NAV)
  KAppNav? appNav;

  @JsonKey(name: GIG_NAV)
  KGigNav? gigNav;

  @JsonKey(name: USER)
  KUser? user;

  @JsonKey(name: TUTOR)
  Tutor? tutor;

  @JsonKey(name: HOST_DATA)
  KSystemHostData? hostData;

  @JsonKey(name: IS_TUTOR_READY, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isTutorReady;

  @JsonKey(name: IS_BIZ_READY, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isBizReady;

  @JsonKey(name: IS_CUSUP_READY, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isCusupReady;

  @JsonKey(name: IS_DOMAIN_ADMIN_READY, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isDomainAdminReady;

  @JsonKey(name: IS_ADMIN_READY, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isAdminReady;

  @JsonKey(name: IS_SUPER_ADMIN, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isSuperAdmin;

  @JsonKey(name: BUSINESS)
  Business? business;

  @JsonKey(name: BUSINESS_MEMBERS)
  List<BusinessMember>? businessMembers;

  /// Extra
  @JsonKey(ignore: true)
  KAppNav? get appCoreAppNav => this.appNav as KAppNav;

  @JsonKey(ignore: true)
  bool isGuest = false;

  @JsonKey(ignore: true)
  bool get isTutor =>
      this.tutor != null && this.tutor!.tutorStatus != Tutor.STATUS_PENDING;

  BusinessMember? getActiveMember() {
    BusinessMember? activeMember;
    try {
      if (businessMembers != null) {
        for (BusinessMember bm in businessMembers!) {
          if (bm.isActive) {
            activeMember = bm;
            break;
          }
        }
      }
    } catch (e) {
      activeMember = null;
    }
    return activeMember;
  }

  // JSON
  KUserSession();

  factory KUserSession.fromJson(Map<String, dynamic> json) =>
      _$KUserSessionFromJson(json);

  Map<String, dynamic> toJson() => _$KUserSessionToJson(this);
}
