// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChatResponse _$GetChatResponseFromJson(Map<String, dynamic> json) {
  return GetChatResponse()
    ..kstatus = zzz_parseInt(json['kstatus'] as String?)
    ..kmessage = json['kmessage'] as String?
    ..ktoken = json['ktoken'] as String?
    ..chat = json['chat'] == null
        ? null
        : KChat.fromJson(json['chat'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetChatResponseToJson(GetChatResponse instance) =>
    <String, dynamic>{
      'kstatus': zzz_itoa(instance.kstatus),
      'kmessage': instance.kmessage,
      'ktoken': instance.ktoken,
      'chat': instance.chat,
    };
