// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kchat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KChatMessage _$KChatMessageFromJson(Map<String, dynamic> json) => KChatMessage()
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
      : KUser.fromJson(json['user'] as Map<String, dynamic>);

Map<String, dynamic> _$KChatMessageToJson(KChatMessage instance) =>
    <String, dynamic>{
      if (instance.messageID case final value?) 'messageID': value,
      if (instance.chatID case final value?) 'chatID': value,
      if (instance.puid case final value?) 'puid': value,
      if (zzz_date2Str(instance.messageDate) case final value?)
        'messageDate': value,
      if (instance.messageType case final value?) 'messageType': value,
      if (instance.message case final value?) 'message': value,
      if (instance.messageStatus case final value?) 'messageStatus': value,
      if (instance.imageData case final value?) 'imgData': value,
      if (instance.refApp case final value?) 'refApp': value,
      if (instance.refID case final value?) 'refID': value,
      if (instance.user?.toJson() case final value?) 'user': value,
    };
