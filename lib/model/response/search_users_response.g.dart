// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUsersResponse _$SearchUsersResponseFromJson(Map<String, dynamic> json) =>
    SearchUsersResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..users = (json['users'] as List<dynamic>?)
          ?.map((e) => KUser.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SearchUsersResponseToJson(
        SearchUsersResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.users?.map((e) => e.toJson()).toList() case final value?)
        'users': value,
    };
