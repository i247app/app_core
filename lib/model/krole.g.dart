// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'krole.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KRole _$KRoleFromJson(Map<String, dynamic> json) => KRole()
  ..puid = json['puid'] as String?
  ..buid = json['buid'] as String?
  ..role = json['role'] as String?
  ..bnm = json['bnm'] as String?
  ..avatarURL = json['avatar'] as String?;

Map<String, dynamic> _$KRoleToJson(KRole instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('puid', instance.puid);
  writeNotNull('buid', instance.buid);
  writeNotNull('role', instance.role);
  writeNotNull('bnm', instance.bnm);
  writeNotNull('avatar', instance.avatarURL);
  return val;
}
