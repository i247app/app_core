// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_chat_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendChatMessageResponse _$SendChatMessageResponseFromJson(
    Map<String, dynamic> json) {
  return SendChatMessageResponse()
    ..kstatus = zzz_parseInt(json['kstatus'] as String?)
    ..kmessage = json['kmessage'] as String?
    ..ktoken = json['ktoken'] as String?
    ..chatMessage = json['chatMessage'] == null
        ? null
        : KChatMessage.fromJson(json['chatMessage'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SendChatMessageResponseToJson(
        SendChatMessageResponse instance) =>
    <String, dynamic>{
      'kstatus': zzz_itoa(instance.kstatus),
      'kmessage': instance.kmessage,
      'ktoken': instance.ktoken,
      'chatMessage': instance.chatMessage,
    };
