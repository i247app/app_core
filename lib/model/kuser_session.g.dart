// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kuser_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KUserSession _$KUserSessionFromJson(Map<String, dynamic> json) => KUserSession()
  ..ktoken = json['ktoken'] as String?
  ..puid = json['puid'] as String?
  ..googleMapAPIKey = json['googleMapAPIKey'] as String?
  ..appNav = json['appNav'] == null
      ? null
      : KAppNav.fromJson(json['appNav'] as Map<String, dynamic>)
  ..gigNav = json['gigNav'] == null
      ? null
      : KGigNav.fromJson(json['gigNav'] as Map<String, dynamic>)
  ..user = json['user'] == null
      ? null
      : KUser.fromJson(json['user'] as Map<String, dynamic>)
  ..tutor = json['tutor'] == null
      ? null
      : Tutor.fromJson(json['tutor'] as Map<String, dynamic>)
  ..hostData = json['hostData'] == null
      ? null
      : KSystemHostData.fromJson(json['hostData'] as Map<String, dynamic>)
  ..isAdminReady = json['isAdminReady'] as bool?
  ..isTutorReady = json['isTutorReady'] as bool?
  ..isBizReady = json['isBizReady'] as bool?
  ..isCusupReady = json['isCUSUPReady'] as bool?
  ..isSuperAdmin = json['isSuperAdmin'] as bool?
  ..business = json['business'] == null
      ? null
      : Business.fromJson(json['business'] as Map<String, dynamic>)
  ..businessMembers = (json['businessMembers'] as List<dynamic>?)
      ?.map((e) => BusinessMember.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$KUserSessionToJson(KUserSession instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('puid', instance.puid);
  writeNotNull('googleMapAPIKey', instance.googleMapAPIKey);
  writeNotNull('appNav', instance.appNav?.toJson());
  writeNotNull('gigNav', instance.gigNav?.toJson());
  writeNotNull('user', instance.user?.toJson());
  writeNotNull('tutor', instance.tutor?.toJson());
  writeNotNull('hostData', instance.hostData?.toJson());
  writeNotNull('isAdminReady', instance.isAdminReady);
  writeNotNull('isTutorReady', instance.isTutorReady);
  writeNotNull('isBizReady', instance.isBizReady);
  writeNotNull('isCUSUPReady', instance.isCusupReady);
  writeNotNull('isSuperAdmin', instance.isSuperAdmin);
  writeNotNull('business', instance.business?.toJson());
  writeNotNull('businessMembers',
      instance.businessMembers?.map((e) => e.toJson()).toList());
  return val;
}
