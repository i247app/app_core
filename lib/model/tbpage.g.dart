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

Map<String, dynamic> _$TBPageToJson(TBPage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('pageID', instance.pageID);
  writeNotNull('chapterID', instance.chapterID);
  writeNotNull('textbookID', instance.textbookID);
  writeNotNull('index', instance.index);
  writeNotNull('title', instance.title);
  writeNotNull('subtitle', instance.subtitle);
  writeNotNull('text', instance.text);
  writeNotNull('mediaURL', instance.mediaURL);
  writeNotNull('mediaType', instance.mediaType);
  writeNotNull('pageStatus', instance.pageStatus);
  writeNotNull('questionID', instance.questionID);
  writeNotNull(
      'questions', instance.questions?.map((e) => e.toJson()).toList());
  return val;
}
