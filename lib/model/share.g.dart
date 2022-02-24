// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Share _$ShareFromJson(Map<String, dynamic> json) => Share()
  ..shareID = json['shareID'] as String?
  ..refPUID = json['refPUID'] as String?
  ..refApp = json['refApp'] as String?
  ..refID = json['refID'] as String?
  ..chapterID = json['chapterID'] as String?
  ..textbookID = json['textbookID'] as String?
  ..mime = json['mime'] as String?
  ..role = json['role'] as String?
  ..action = json['action'] as String?
  ..shareDate = zzz_str2Date(json['shareDate'] as String?);

Map<String, dynamic> _$ShareToJson(Share instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('shareID', instance.shareID);
  writeNotNull('refPUID', instance.refPUID);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('refID', instance.refID);
  writeNotNull('chapterID', instance.chapterID);
  writeNotNull('textbookID', instance.textbookID);
  writeNotNull('mime', instance.mime);
  writeNotNull('role', instance.role);
  writeNotNull('action', instance.action);
  writeNotNull('shareDate', zzz_date2Str(instance.shareDate));
  return val;
}
