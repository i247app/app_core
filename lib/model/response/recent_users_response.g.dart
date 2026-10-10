// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentUsersResponse _$RecentUsersResponseFromJson(Map<String, dynamic> json) =>
    RecentUsersResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..users = (json['recentUsers'] as List<dynamic>?)
          ?.map((e) => KUser.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$RecentUsersResponseToJson(RecentUsersResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('recentUsers', instance.users?.map((e) => e.toJson()).toList());
  return val;
}
