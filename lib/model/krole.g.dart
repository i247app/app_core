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

Map<String, dynamic> _$KRoleToJson(KRole instance) => <String, dynamic>{
      if (instance.puid case final value?) 'puid': value,
      if (instance.buid case final value?) 'buid': value,
      if (instance.role case final value?) 'role': value,
      if (instance.bnm case final value?) 'bnm': value,
      if (instance.avatarURL case final value?) 'avatar': value,
    };
