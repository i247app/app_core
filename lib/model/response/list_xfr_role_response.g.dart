// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_xfr_role_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListXFRRoleResponse _$ListXFRRoleResponseFromJson(Map<String, dynamic> json) =>
    ListXFRRoleResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..roles = (json['xfrRoles'] as List<dynamic>?)
          ?.map((e) => KRole.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ListXFRRoleResponseToJson(
        ListXFRRoleResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.roles?.map((e) => e.toJson()).toList() case final value?)
        'xfrRoles': value,
    };
