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

Map<String, dynamic> _$ListXFRRoleResponseToJson(ListXFRRoleResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('xfrRoles', instance.roles?.map((e) => e.toJson()).toList());
  return val;
}
