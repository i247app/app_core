// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textbook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Textbook _$TextbookFromJson(Map<String, dynamic> json) => Textbook()
  ..textbookID = json['textbookID'] as String?
  ..courseID = json['courseID'] as String?
  ..title = json['title'] as String?
  ..subtitle = json['subtitle'] as String?
  ..text = json['text'] as String?
  ..mediaURL = json['mediaURL'] as String?
  ..mediaType = json['mediaType'] as String?
  ..textbookStatus = json['textbookStatus'] as String?
  ..level = json['level'] as String?
  ..grade = json['grade'] as String?
  ..tags = json['tags'] as String?
  ..chapters = (json['chapters'] as List<dynamic>?)
      ?.map((e) => Chapter.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TextbookToJson(Textbook instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('textbookID', instance.textbookID);
  writeNotNull('courseID', instance.courseID);
  writeNotNull('title', instance.title);
  writeNotNull('subtitle', instance.subtitle);
  writeNotNull('text', instance.text);
  writeNotNull('mediaURL', instance.mediaURL);
  writeNotNull('mediaType', instance.mediaType);
  writeNotNull('textbookStatus', instance.textbookStatus);
  writeNotNull('level', instance.level);
  writeNotNull('grade', instance.grade);
  writeNotNull('tags', instance.tags);
  writeNotNull('chapters', instance.chapters?.map((e) => e.toJson()).toList());
  return val;
}
