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
  ..isTutorReady = zzz_str2Bool(json['isTutorReady'] as String?)
  ..isBizReady = zzz_str2Bool(json['isBizReady'] as String?)
  ..isCusupReady = zzz_str2Bool(json['isCUSUPReady'] as String?)
  ..isDomainAdminReady = zzz_str2Bool(json['isDomainAdminReady'] as String?)
  ..isAdminReady = zzz_str2Bool(json['isAdminReady'] as String?)
  ..isSuperAdmin = zzz_str2Bool(json['isSuperAdmin'] as String?)
  ..isForceUpdate = zzz_str2Bool(json['isForceUpdate'] as String?)
  ..business = json['business'] == null
      ? null
      : Business.fromJson(json['business'] as Map<String, dynamic>)
  ..businessMembers = (json['businessMembers'] as List<dynamic>?)
      ?.map((e) => BusinessMember.fromJson(e as Map<String, dynamic>))
      .toList()
  ..awsInfo = json['awsInfo'] == null
      ? null
      : KAWSInfo.fromJson(json['awsInfo'] as Map<String, dynamic>);

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
  writeNotNull('isTutorReady', zzz_bool2Str(instance.isTutorReady));
  writeNotNull('isBizReady', zzz_bool2Str(instance.isBizReady));
  writeNotNull('isCUSUPReady', zzz_bool2Str(instance.isCusupReady));
  writeNotNull('isDomainAdminReady', zzz_bool2Str(instance.isDomainAdminReady));
  writeNotNull('isAdminReady', zzz_bool2Str(instance.isAdminReady));
  writeNotNull('isSuperAdmin', zzz_bool2Str(instance.isSuperAdmin));
  writeNotNull('isForceUpdate', zzz_bool2Str(instance.isForceUpdate));
  writeNotNull('business', instance.business?.toJson());
  writeNotNull('businessMembers',
      instance.businessMembers?.map((e) => e.toJson()).toList());
  writeNotNull('awsInfo', instance.awsInfo?.toJson());
  return val;
}
