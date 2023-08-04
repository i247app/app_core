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

Map<String, dynamic> _$KChatToJson(KChat instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('chatID', instance.chatID);
  writeNotNull('chatName', instance.chatName);
  writeNotNull('previewMessageID', instance.previewMessageID);
  writeNotNull('previewMessagePUID', instance.previewMessagePUID);
  writeNotNull('previewMessage', instance.previewMessage);
  writeNotNull(
      'chatMessages', instance.kMessages?.map((e) => e.toJson()).toList());
  writeNotNull('members', instance.kMembers?.map((e) => e.toJson()).toList());
  writeNotNull('activeDate', zzz_date2Str(instance.activeDate));
  writeNotNull('refID', instance.refID);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('domain', instance.domain);
  return val;
}
