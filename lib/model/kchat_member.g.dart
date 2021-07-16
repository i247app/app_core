// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kchat_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KChatMember _$KChatMemberFromJson(Map<String, dynamic> json) {
  return KChatMember()
    ..chatID = json['chatID'] as String?
    ..puid = json['puid'] as String?
    ..kunm = json['kunm'] as String?
    ..phone = json['fone'] as String?
    ..firstName = json['firstName'] as String?
    ..middleName = json['middleName'] as String?
    ..lastName = json['lastName'] as String?
    ..avatar = json['avatar'] as String?
    ..memberStatus = json['memberStatus'] as String?
    ..domain = json['domain'] as String?
    ..refID = json['refID'] as String?
    ..refApp = json['refApp'] as String?;
}

Map<String, dynamic> _$KChatMemberToJson(KChatMember instance) =>
    <String, dynamic>{
      'chatID': instance.chatID,
      'puid': instance.puid,
      'kunm': instance.kunm,
      'fone': instance.phone,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'avatar': instance.avatar,
      'memberStatus': instance.memberStatus,
      'domain': instance.domain,
      'refID': instance.refID,
      'refApp': instance.refApp,
    };
