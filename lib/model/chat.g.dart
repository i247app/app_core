// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCoreChat _$AppCoreChatFromJson(Map<String, dynamic> json) {
  return AppCoreChat()
    ..chatID = json['chatID'] as String?
    ..chatName = json['chatName'] as String?
    ..previewMessageID = json['previewMessageID'] as String?
    ..previewMessagePUID = json['previewMessagePUID'] as String?
    ..previewMessage = json['previewMessage'] as String?
    ..messages = (json['chatMessages'] as List<dynamic>?)
        ?.map((e) => AppCoreChatMessage.fromJson(e as Map<String, dynamic>))
        .toList()
    ..members = (json['members'] as List<dynamic>?)
        ?.map((e) => AppCoreChatMember.fromJson(e as Map<String, dynamic>))
        .toList()
    ..activeDate = zzz_str2Date(json['activeDate'] as String?)
    ..refID = json['refID'] as String?
    ..refApp = json['refApp'] as String?;
}

Map<String, dynamic> _$AppCoreChatToJson(AppCoreChat instance) =>
    <String, dynamic>{
      'chatID': instance.chatID,
      'chatName': instance.chatName,
      'previewMessageID': instance.previewMessageID,
      'previewMessagePUID': instance.previewMessagePUID,
      'previewMessage': instance.previewMessage,
      'chatMessages': instance.messages,
      'members': instance.members,
      'activeDate': zzz_date2Str(instance.activeDate),
      'refID': instance.refID,
      'refApp': instance.refApp,
    };
