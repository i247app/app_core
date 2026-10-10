// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter()
  ..chapterID = json['chapterID'] as String?
  ..textbookID = json['textbookID'] as String?
  ..title = json['title'] as String?
  ..subtitle = json['subtitle'] as String?
  ..text = json['text'] as String?
  ..mediaURL = json['mediaURL'] as String?
  ..mediaType = json['mediaType'] as String?
  ..chapterStatus = json['chapterStatus'] as String?
  ..pages = (json['pages'] as List<dynamic>?)
      ?.map((e) => TBPage.fromJson(e as Map<String, dynamic>))
      .toList()
  ..chapterNumber = json['chapterNumber'] as String?
  ..grade = json['grade'] as String?;

Map<String, dynamic> _$ChapterToJson(Chapter instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('chapterID', instance.chapterID);
  writeNotNull('textbookID', instance.textbookID);
  writeNotNull('title', instance.title);
  writeNotNull('subtitle', instance.subtitle);
  writeNotNull('text', instance.text);
  writeNotNull('mediaURL', instance.mediaURL);
  writeNotNull('mediaType', instance.mediaType);
  writeNotNull('chapterStatus', instance.chapterStatus);
  writeNotNull('pages', instance.pages?.map((e) => e.toJson()).toList());
  writeNotNull('chapterNumber', instance.chapterNumber);
  writeNotNull('grade', instance.grade);
  return val;
}
