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
    SendChatMessageResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('chatMessage', instance.chatMessage?.toJson());
  return val;
}
