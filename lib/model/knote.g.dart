// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KNote _$KNoteFromJson(Map<String, dynamic> json) => KNote()
  ..id = json['id'] as String?
  ..noteID = json['noteID'] as String?
  ..action = json['action'] as String?
  ..puid = json['puid'] as String?
  ..refApp = json['refApp'] as String?
  ..refID = json['refID'] as String?
  ..messageDate = zzz_str2Date(json['messageDate'] as String?)
  ..messageType = json['messageType'] as String?
  ..message = json['message'] as String?
  ..noteStatus = json['noteStatus'] as String?
  ..imgData = json['imageData'] as String?
  ..user = json['user'] == null
      ? null
      : KUser.fromJson(json['user'] as Map<String, dynamic>);

Map<String, dynamic> _$KNoteToJson(KNote instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('noteID', instance.noteID);
  writeNotNull('action', instance.action);
  writeNotNull('puid', instance.puid);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('refID', instance.refID);
  writeNotNull('messageDate', zzz_date2Str(instance.messageDate));
  writeNotNull('messageType', instance.messageType);
  writeNotNull('message', instance.message);
  writeNotNull('noteStatus', instance.noteStatus);
  writeNotNull('imageData', instance.imgData);
  writeNotNull('user', instance.user?.toJson());
  return val;
}
