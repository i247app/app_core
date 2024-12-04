// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kp2p_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KP2PSession _$KP2PSessionFromJson(Map<String, dynamic> json) => KP2PSession()
  ..id = json['id'] as String?
  ..chatID = json['chatID'] as String?
  ..refApp = json['refApp'] as String?
  ..refID = json['refID'] as String?
  ..adminPUID = json['adminPUID'] as String?
  ..adminName = json['adminName'] as String?
  ..adminAvatarURL = json['adminAvatarURL'] as String?;

Map<String, dynamic> _$KP2PSessionToJson(KP2PSession instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.chatID case final value?) 'chatID': value,
      if (instance.refApp case final value?) 'refApp': value,
      if (instance.refID case final value?) 'refID': value,
      if (instance.adminPUID case final value?) 'adminPUID': value,
      if (instance.adminName case final value?) 'adminName': value,
      if (instance.adminAvatarURL case final value?) 'adminAvatarURL': value,
    };
