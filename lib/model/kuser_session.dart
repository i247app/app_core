import 'package:app_core/model/kapp_nav.dart';
import 'package:app_core/model/ksystem_host_data.dart';
import 'package:app_core/model/kuser.dart';
import 'package:json_annotation/json_annotation.dart';

class KUserSession {
  static const String KTOKEN = "ktoken";
  static const String PUID = "puid";
  static const String GOOGLE_MAP_API_KEY = "googleMapAPIKey";
  static const String HOST_DATA = "hostData";

  @JsonKey(name: KTOKEN)
  String? ktoken;

  @JsonKey(name: PUID)
  String? puid;

  @JsonKey(name: GOOGLE_MAP_API_KEY)
  String? googleMapAPIKey;

  @JsonKey(ignore: true)
  KAppNav? appCoreAppNav;

  @JsonKey(ignore: true)
  KUser? appCoreUser;

  @JsonKey(name: HOST_DATA)
  KSystemHostData? hostData;

  // JSON
  KUserSession();
}
