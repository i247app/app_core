// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCoreChatMessage _$AppCoreChatMessageFromJson(Map<String, dynamic> json) {
  return AppCoreChatMessage()
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
    ..user = json['user'] == null
        ? null
        : AppCoreUser.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AppCoreChatMessageToJson(AppCoreChatMessage instance) =>
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
      'user': instance.user,
    };
