// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_add_members_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatAddMembersResponse _$ChatAddMembersResponseFromJson(
    Map<String, dynamic> json) {
  return ChatAddMembersResponse()
    ..kstatus = zzz_parseInt(json['kstatus'] as String?)
    ..kmessage = json['kmessage'] as String?
    ..ktoken = json['ktoken'] as String?
    ..members = (json['members'] as List<dynamic>?)
        ?.map((e) => KChatMember.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$ChatAddMembersResponseToJson(
        ChatAddMembersResponse instance) =>
    <String, dynamic>{
      'kstatus': zzz_itoa(instance.kstatus),
      'kmessage': instance.kmessage,
      'ktoken': instance.ktoken,
      'members': instance.members,
    };
