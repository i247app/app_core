// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kchat_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KChatMember _$KChatMemberFromJson(Map<String, dynamic> json) => KChatMember()
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

Map<String, dynamic> _$KChatMemberToJson(KChatMember instance) =>
    <String, dynamic>{
      if (instance.chatID case final value?) 'chatID': value,
      if (instance.puid case final value?) 'puid': value,
      if (instance.kunm case final value?) 'kunm': value,
      if (instance.phone case final value?) 'fone': value,
      if (instance.firstName case final value?) 'firstName': value,
      if (instance.middleName case final value?) 'middleName': value,
      if (instance.lastName case final value?) 'lastName': value,
      if (instance.avatar case final value?) 'avatar': value,
      if (instance.memberStatus case final value?) 'memberStatus': value,
      if (instance.domain case final value?) 'domain': value,
      if (instance.refID case final value?) 'refID': value,
      if (instance.refApp case final value?) 'refApp': value,
    };
