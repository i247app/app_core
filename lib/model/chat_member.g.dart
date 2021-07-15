// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCoreChatMember _$AppCoreChatMemberFromJson(Map<String, dynamic> json) {
  return AppCoreChatMember()
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

Map<String, dynamic> _$AppCoreChatMemberToJson(AppCoreChatMember instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('chatID', instance.chatID);
  writeNotNull('puid', instance.puid);
  writeNotNull('kunm', instance.kunm);
  writeNotNull('fone', instance.phone);
  writeNotNull('firstName', instance.firstName);
  writeNotNull('middleName', instance.middleName);
  writeNotNull('lastName', instance.lastName);
  writeNotNull('avatar', instance.avatar);
  writeNotNull('memberStatus', instance.memberStatus);
  writeNotNull('domain', instance.domain);
  writeNotNull('refID', instance.refID);
  writeNotNull('refApp', instance.refApp);
  return val;
}
