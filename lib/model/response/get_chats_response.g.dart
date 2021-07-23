// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_chats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGetChatsResponse _$KGetChatsResponseFromJson(Map<String, dynamic> json) {
  return KGetChatsResponse()
    ..kstatus = zzz_parseInt(json['kstatus'] as String?)
    ..kmessage = json['kmessage'] as String?
    ..ktoken = json['ktoken'] as String?
    ..chats = (json['chats'] as List<dynamic>?)
        ?.map((e) => KChat.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$KGetChatsResponseToJson(KGetChatsResponse instance) =>
    <String, dynamic>{
      'kstatus': zzz_itoa(instance.kstatus),
      'kmessage': instance.kmessage,
      'ktoken': instance.ktoken,
      'chats': instance.chats,
    };
