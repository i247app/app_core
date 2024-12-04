// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChatResponse _$GetChatResponseFromJson(Map<String, dynamic> json) =>
    GetChatResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..chat = json['chat'] == null
          ? null
          : KChat.fromJson(json['chat'] as Map<String, dynamic>);

Map<String, dynamic> _$GetChatResponseToJson(GetChatResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.chat?.toJson() case final value?) 'chat': value,
    };
