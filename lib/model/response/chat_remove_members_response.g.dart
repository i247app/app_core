// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_remove_members_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KChatRemoveMembersResponse _$KChatRemoveMembersResponseFromJson(
    Map<String, dynamic> json) {
  return KChatRemoveMembersResponse()
    ..kstatus = zzz_parseInt(json['kstatus'] as String?)
    ..kmessage = json['kmessage'] as String?
    ..ktoken = json['ktoken'] as String?
    ..members = (json['members'] as List<dynamic>?)
        ?.map((e) => KChatMember.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$KChatRemoveMembersResponseToJson(
        KChatRemoveMembersResponse instance) =>
    <String, dynamic>{
      'kstatus': zzz_itoa(instance.kstatus),
      'kmessage': instance.kmessage,
      'ktoken': instance.ktoken,
      'members': instance.members,
    };
