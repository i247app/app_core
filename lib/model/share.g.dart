// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Share _$ShareFromJson(Map<String, dynamic> json) => Share()
  ..chapterID = json['chapterID'] as String?
  ..textbookID = json['textbookID'] as String?
  ..role = json['role'] as String?
  ..refPUID = json['refPUID'] as String?
  ..refApp = json['refApp'] as String?
  ..refID = json['refID'] as String?
  ..action = json['action'] as String?
  ..req = json['req'] as String?
  ..svc = json['svc'] as String?;

Map<String, dynamic> _$ShareToJson(Share instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('chapterID', instance.chapterID);
  writeNotNull('textbookID', instance.textbookID);
  writeNotNull('role', instance.role);
  writeNotNull('refPUID', instance.refPUID);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('refID', instance.refID);
  writeNotNull('action', instance.action);
  writeNotNull('req', instance.req);
  writeNotNull('svc', instance.svc);
  return val;
}
