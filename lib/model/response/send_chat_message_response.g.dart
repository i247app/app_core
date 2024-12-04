// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_chat_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendChatMessageResponse _$SendChatMessageResponseFromJson(
        Map<String, dynamic> json) =>
    SendChatMessageResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..chatMessage = json['chatMessage'] == null
          ? null
          : KChatMessage.fromJson(json['chatMessage'] as Map<String, dynamic>);

Map<String, dynamic> _$SendChatMessageResponseToJson(
        SendChatMessageResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.chatMessage?.toJson() case final value?)
        'chatMessage': value,
    };
