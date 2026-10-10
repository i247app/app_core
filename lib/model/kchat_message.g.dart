// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kchat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KChatMessage _$KChatMessageFromJson(Map<String, dynamic> json) => KChatMessage()
  ..messageID = json['messageID'] as String?
  ..chatID = json['chatID'] as String?
  ..puid = json['puid'] as String?
  ..messageDate = zzz_str2Date(json['messageDate'] as String?)
  ..messageType = json['messageType'] as String?
  ..message = json['message'] as String?
  ..messageStatus = json['messageStatus'] as String?
  ..imageData = json['imgData'] as String?
  ..refApp = json['refApp'] as String?
  ..refID = json['refID'] as String?
  ..user = json['user'] == null
      ? null
      : KUser.fromJson(json['user'] as Map<String, dynamic>);

Map<String, dynamic> _$KChatMessageToJson(KChatMessage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('messageID', instance.messageID);
  writeNotNull('chatID', instance.chatID);
  writeNotNull('puid', instance.puid);
  writeNotNull('messageDate', zzz_date2Str(instance.messageDate));
  writeNotNull('messageType', instance.messageType);
  writeNotNull('message', instance.message);
  writeNotNull('messageStatus', instance.messageStatus);
  writeNotNull('imgData', instance.imageData);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('refID', instance.refID);
  writeNotNull('user', instance.user?.toJson());
  return val;
}
