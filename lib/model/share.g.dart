// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Share _$ShareFromJson(Map<String, dynamic> json) => Share()
  ..shareID = json['shareID'] as String?
  ..refApp = json['refApp'] as String?
  ..refID = json['refID'] as String?
  ..role = json['role'] as String?
  ..action = json['action'] as String?
  ..refPUID = json['refPUID'] as String?
  ..chapterID = json['chapterID'] as String?
  ..textbookID = json['textbookID'] as String?
  ..mime = json['mime'] as String?
  ..id = json['id'] as String?
  ..index = json['index'] as String?
  ..shareDate = zzz_str2Date(json['shareDate'] as String?);

Map<String, dynamic> _$ShareToJson(Share instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('shareID', instance.shareID);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('refID', instance.refID);
  writeNotNull('role', instance.role);
  writeNotNull('action', instance.action);
  writeNotNull('refPUID', instance.refPUID);
  writeNotNull('chapterID', instance.chapterID);
  writeNotNull('textbookID', instance.textbookID);
  writeNotNull('mime', instance.mime);
  writeNotNull('id', instance.id);
  writeNotNull('index', instance.index);
  writeNotNull('shareDate', zzz_date2Str(instance.shareDate));
  return val;
}
