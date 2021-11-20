// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_chats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGetChatsResponse _$KGetChatsResponseFromJson(Map<String, dynamic> json) =>
    KGetChatsResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..chats = (json['chats'] as List<dynamic>?)
          ?.map((e) => KChat.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KGetChatsResponseToJson(KGetChatsResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('chats', instance.chats?.map((e) => e.toJson()).toList());
  return val;
}
