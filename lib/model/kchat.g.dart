// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kchat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KChat _$KChatFromJson(Map<String, dynamic> json) => KChat()
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

Map<String, dynamic> _$KChatToJson(KChat instance) => <String, dynamic>{
      if (instance.chatID case final value?) 'chatID': value,
      if (instance.chatName case final value?) 'chatName': value,
      if (instance.previewMessageID case final value?)
        'previewMessageID': value,
      if (instance.previewMessagePUID case final value?)
        'previewMessagePUID': value,
      if (instance.previewMessage case final value?) 'previewMessage': value,
      if (instance.kMessages?.map((e) => e.toJson()).toList() case final value?)
        'chatMessages': value,
      if (instance.kMembers?.map((e) => e.toJson()).toList() case final value?)
        'members': value,
      if (zzz_date2Str(instance.activeDate) case final value?)
        'activeDate': value,
      if (instance.refID case final value?) 'refID': value,
      if (instance.refApp case final value?) 'refApp': value,
      if (instance.domain case final value?) 'domain': value,
    };
