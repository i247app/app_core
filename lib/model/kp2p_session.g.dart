// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kp2p_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KP2PSession _$KP2PSessionFromJson(Map<String, dynamic> json) {
  return KP2PSession()
    ..id = json['id'] as String?
    ..chatID = json['chatID'] as String?
    ..refApp = json['refApp'] as String?
    ..refID = json['refID'] as String?
    ..adminPUID = json['adminPUID'] as String?
    ..adminName = json['adminName'] as String?
    ..adminAvatarURL = json['adminAvatarURL'] as String?;
}

Map<String, dynamic> _$KP2PSessionToJson(KP2PSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatID': instance.chatID,
      'refApp': instance.refApp,
      'refID': instance.refID,
      'adminPUID': instance.adminPUID,
      'adminName': instance.adminName,
      'adminAvatarURL': instance.adminAvatarURL,
    };
