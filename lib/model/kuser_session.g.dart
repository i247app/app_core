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
      : KAWSInfo.fromJson(json['awsInfo'] as Map<String, dynamic>)
  ..isSecure = zzz_str2Bool(json['isSecure'] as String?);

Map<String, dynamic> _$KUserSessionToJson(KUserSession instance) =>
    <String, dynamic>{
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.puid case final value?) 'puid': value,
      if (instance.googleMapAPIKey case final value?) 'googleMapAPIKey': value,
      if (instance.appNav?.toJson() case final value?) 'appNav': value,
      if (instance.gigNav?.toJson() case final value?) 'gigNav': value,
      if (instance.user?.toJson() case final value?) 'user': value,
      if (instance.tutor?.toJson() case final value?) 'tutor': value,
      if (instance.hostData?.toJson() case final value?) 'hostData': value,
      if (zzz_bool2Str(instance.isTutorReady) case final value?)
        'isTutorReady': value,
      if (zzz_bool2Str(instance.isBizReady) case final value?)
        'isBizReady': value,
      if (zzz_bool2Str(instance.isCusupReady) case final value?)
        'isCUSUPReady': value,
      if (zzz_bool2Str(instance.isDomainAdminReady) case final value?)
        'isDomainAdminReady': value,
      if (zzz_bool2Str(instance.isAdminReady) case final value?)
        'isAdminReady': value,
      if (zzz_bool2Str(instance.isSuperAdmin) case final value?)
        'isSuperAdmin': value,
      if (zzz_bool2Str(instance.isForceUpdate) case final value?)
        'isForceUpdate': value,
      if (instance.business?.toJson() case final value?) 'business': value,
      if (instance.businessMembers?.map((e) => e.toJson()).toList()
          case final value?)
        'businessMembers': value,
      if (instance.awsInfo?.toJson() case final value?) 'awsInfo': value,
      if (zzz_bool2Str(instance.isSecure) case final value?) 'isSecure': value,
    };
