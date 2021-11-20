// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_add_members_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatAddMembersResponse _$ChatAddMembersResponseFromJson(
        Map<String, dynamic> json) =>
    ChatAddMembersResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..members = (json['members'] as List<dynamic>?)
          ?.map((e) => KChatMember.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ChatAddMembersResponseToJson(
    ChatAddMembersResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('members', instance.members?.map((e) => e.toJson()).toList());
  return val;
}
