// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUsersResponse _$SearchUsersResponseFromJson(Map<String, dynamic> json) {
  return SearchUsersResponse()
    ..kstatus = zzz_parseInt(json['kstatus'] as String?)
    ..kmessage = json['kmessage'] as String?
    ..ktoken = json['ktoken'] as String?
    ..users = (json['users'] as List<dynamic>?)
        ?.map((e) => KUser.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$SearchUsersResponseToJson(
        SearchUsersResponse instance) =>
    <String, dynamic>{
      'kstatus': zzz_itoa(instance.kstatus),
      'kmessage': instance.kmessage,
      'ktoken': instance.ktoken,
      'users': instance.users,
    };
