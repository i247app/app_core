// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCoreUserSession _$AppCoreUserSessionFromJson(Map<String, dynamic> json) {
  return AppCoreUserSession()
    ..ktoken = json['ktoken'] as String?
    ..puid = json['puid'] as String?
    ..onlineMode = json['onlineMode'] as String?
    ..googleMapAPIKey = json['googleMapAPIKey'] as String?
    ..appNav = json['appNav'] == null
        ? null
        : AppCoreAppNav.fromJson(json['appNav'] as Map<String, dynamic>)
    ..user = json['user'] == null
        ? null
        : AppCoreUser.fromJson(json['user'] as Map<String, dynamic>)
    ..hostData = json['hostData'] == null
        ? null
        : AppCoreSystemHostData.fromJson(
            json['hostData'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AppCoreUserSessionToJson(AppCoreUserSession instance) =>
    <String, dynamic>{
      'ktoken': instance.ktoken,
      'puid': instance.puid,
      'onlineMode': instance.onlineMode,
      'googleMapAPIKey': instance.googleMapAPIKey,
      'appNav': instance.appNav,
      'user': instance.user,
      'hostData': instance.hostData,
    };
