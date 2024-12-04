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

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      if (instance.chapterID case final value?) 'chapterID': value,
      if (instance.textbookID case final value?) 'textbookID': value,
      if (instance.title case final value?) 'title': value,
      if (instance.subtitle case final value?) 'subtitle': value,
      if (instance.text case final value?) 'text': value,
      if (instance.mediaURL case final value?) 'mediaURL': value,
      if (instance.mediaType case final value?) 'mediaType': value,
      if (instance.chapterStatus case final value?) 'chapterStatus': value,
      if (instance.pages?.map((e) => e.toJson()).toList() case final value?)
        'pages': value,
      if (instance.chapterNumber case final value?) 'chapterNumber': value,
      if (instance.grade case final value?) 'grade': value,
    };
