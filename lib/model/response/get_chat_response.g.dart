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

Map<String, dynamic> _$GetChatResponseToJson(GetChatResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('chat', instance.chat?.toJson());
  return val;
}
