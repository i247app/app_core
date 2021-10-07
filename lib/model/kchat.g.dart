// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kchat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KChat _$KChatFromJson(Map<String, dynamic> json) {
  return KChat()
    ..chatID = json['chatID'] as String?
    ..chatName = json['chatName'] as String?
    ..previewMessageID = json['previewMessageID'] as String?
    ..previewMessagePUID = json['previewMessagePUID'] as String?
    ..previewMessage = json['previewMessage'] as String?
    ..kMessages = (json['chatMessages'] as List<dynamic>?)
        ?.map((e) => KChatMessage.fromJson(e as Map<String, dynamic>))
        .toList()
    ..kMembers = (json['members'] as List<dynamic>?)
        ?.map((e) => KChatMember.fromJson(e as Map<String, dynamic>))
        .toList()
    ..activeDate = zzz_str2Date(json['activeDate'] as String?)
    ..refID = json['refID'] as String?
    ..refApp = json['refApp'] as String?
    ..domain = json['domain'] as String?;
}

Map<String, dynamic> _$KChatToJson(KChat instance) => <String, dynamic>{
      'chatID': instance.chatID,
      'chatName': instance.chatName,
      'previewMessageID': instance.previewMessageID,
      'previewMessagePUID': instance.previewMessagePUID,
      'previewMessage': instance.previewMessage,
      'chatMessages': instance.kMessages,
      'members': instance.kMembers,
      'activeDate': zzz_date2Str(instance.activeDate),
      'refID': instance.refID,
      'refApp': instance.refApp,
      'domain': instance.domain,
    };
