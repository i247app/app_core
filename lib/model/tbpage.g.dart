// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tbpage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TBPage _$TBPageFromJson(Map<String, dynamic> json) => TBPage()
  ..pageID = json['pageID'] as String?
  ..chapterID = json['chapterID'] as String?
  ..textbookID = json['textbookID'] as String?
  ..index = json['index'] as String?
  ..title = json['title'] as String?
  ..subtitle = json['subtitle'] as String?
  ..text = json['text'] as String?
  ..mediaURL = json['mediaURL'] as String?
  ..mediaType = json['mediaType'] as String?
  ..pageStatus = json['pageStatus'] as String?
  ..questionID = json['questionID'] as String?
  ..questions = (json['questions'] as List<dynamic>?)
      ?.map((e) => KQuestion.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TBPageToJson(TBPage instance) => <String, dynamic>{
      if (instance.pageID case final value?) 'pageID': value,
      if (instance.chapterID case final value?) 'chapterID': value,
      if (instance.textbookID case final value?) 'textbookID': value,
      if (instance.index case final value?) 'index': value,
      if (instance.title case final value?) 'title': value,
      if (instance.subtitle case final value?) 'subtitle': value,
      if (instance.text case final value?) 'text': value,
      if (instance.mediaURL case final value?) 'mediaURL': value,
      if (instance.mediaType case final value?) 'mediaType': value,
      if (instance.pageStatus case final value?) 'pageStatus': value,
      if (instance.questionID case final value?) 'questionID': value,
      if (instance.questions?.map((e) => e.toJson()).toList() case final value?)
        'questions': value,
    };
