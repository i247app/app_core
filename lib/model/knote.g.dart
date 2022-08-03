// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KNote _$KNoteFromJson(Map<String, dynamic> json) => KNote()
  ..puid = json['puid'] as String?
  ..noteDate = zzz_str2Date(json['noteDate'] as String?)
  ..messageType = json['messageType'] as String?
  ..body = json['body'] as String?
  ..imageData = json['imgData'] as String?
  ..refApp = json['refApp'] as String?
  ..refID = json['refID'] as String?;

Map<String, dynamic> _$KNoteToJson(KNote instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('puid', instance.puid);
  writeNotNull('noteDate', zzz_date2Str(instance.noteDate));
  writeNotNull('messageType', instance.messageType);
  writeNotNull('body', instance.body);
  writeNotNull('imgData', instance.imageData);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('refID', instance.refID);
  return val;
}
