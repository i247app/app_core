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

Map<String, dynamic> _$KP2PSessionToJson(KP2PSession instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('chatID', instance.chatID);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('refID', instance.refID);
  writeNotNull('adminPUID', instance.adminPUID);
  writeNotNull('adminName', instance.adminName);
  writeNotNull('adminAvatarURL', instance.adminAvatarURL);
  return val;
}
