// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kchat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KChatMessage _$KChatMessageFromJson(Map<String, dynamic> json) {
  return KChatMessage()
    ..messageID = json['messageID'] as String?
    ..chatID = json['chatID'] as String?
    ..puid = json['puid'] as String?
    ..messageDate = zzz_str2Date(json['messageDate'] as String?)
    ..messageType = json['messageType'] as String?
    ..message = json['message'] as String?
    ..messageStatus = json['messageStatus'] as String?
    ..imageData = json['imgData'] as String?
    ..refApp = json['refApp'] as String?
    ..refID = json['refID'] as String?
    ..kUser = json['user'] == null
        ? null
        : KUser.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$KChatMessageToJson(KChatMessage instance) =>
    <String, dynamic>{
      'messageID': instance.messageID,
      'chatID': instance.chatID,
      'puid': instance.puid,
      'messageDate': zzz_date2Str(instance.messageDate),
      'messageType': instance.messageType,
      'message': instance.message,
      'messageStatus': instance.messageStatus,
      'imgData': instance.imageData,
      'refApp': instance.refApp,
      'refID': instance.refID,
      'user': instance.kUser,
    };
