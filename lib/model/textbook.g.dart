// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textbook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Textbook _$TextbookFromJson(Map<String, dynamic> json) => Textbook()
  ..textbookID = json['textbookID'] as String?
  ..courseID = json['courseID'] as String?
  ..title = json['title'] as String?
  ..subject = json['subject'] as String?
  ..category = json['category'] as String?
  ..chapterNumber = json['chapterNumber'] as String?
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

Map<String, dynamic> _$TextbookToJson(Textbook instance) => <String, dynamic>{
      if (instance.textbookID case final value?) 'textbookID': value,
      if (instance.courseID case final value?) 'courseID': value,
      if (instance.title case final value?) 'title': value,
      if (instance.subject case final value?) 'subject': value,
      if (instance.category case final value?) 'category': value,
      if (instance.chapterNumber case final value?) 'chapterNumber': value,
      if (instance.subtitle case final value?) 'subtitle': value,
      if (instance.text case final value?) 'text': value,
      if (instance.mediaURL case final value?) 'mediaURL': value,
      if (instance.mediaType case final value?) 'mediaType': value,
      if (instance.textbookStatus case final value?) 'textbookStatus': value,
      if (instance.level case final value?) 'level': value,
      if (instance.grade case final value?) 'grade': value,
      if (instance.tags case final value?) 'tags': value,
      if (instance.chapters?.map((e) => e.toJson()).toList() case final value?)
        'chapters': value,
    };
