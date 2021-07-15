// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'p2p_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCoreP2PSession _$AppCoreP2PSessionFromJson(Map<String, dynamic> json) {
  return AppCoreP2PSession()
    ..id = json['id'] as String?
    ..chatID = json['chatID'] as String?
    ..refApp = json['refApp'] as String?
    ..refID = json['refID'] as String?
    ..adminPUID = json['adminPUID'] as String?
    ..adminName = json['adminName'] as String?
    ..adminAvatarURL = json['adminAvatarURL'] as String?;
}

Map<String, dynamic> _$AppCoreP2PSessionToJson(AppCoreP2PSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatID': instance.chatID,
      'refApp': instance.refApp,
      'refID': instance.refID,
      'adminPUID': instance.adminPUID,
      'adminName': instance.adminName,
      'adminAvatarURL': instance.adminAvatarURL,
    };
