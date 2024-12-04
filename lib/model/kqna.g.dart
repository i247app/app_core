// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kqna.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KQNA _$KQNAFromJson(Map<String, dynamic> json) => KQNA()
  ..qnaID = json['qnaID'] as String?
  ..qnaType = json['qnaType'] as String?
  ..title = json['title'] as String?
  ..subtitle = json['subtitle'] as String?
  ..text = json['text'] as String?
  ..mediaURL = json['mediaURL'] as String?
  ..mediaType = json['mediaType'] as String?
  ..qnaStatus = json['qnaStatus'] as String?
  ..questions = (json['questions'] as List<dynamic>?)
      ?.map((e) => KQuestion.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$KQNAToJson(KQNA instance) => <String, dynamic>{
      if (instance.qnaID case final value?) 'qnaID': value,
      if (instance.qnaType case final value?) 'qnaType': value,
      if (instance.title case final value?) 'title': value,
      if (instance.subtitle case final value?) 'subtitle': value,
      if (instance.text case final value?) 'text': value,
      if (instance.mediaURL case final value?) 'mediaURL': value,
      if (instance.mediaType case final value?) 'mediaType': value,
      if (instance.qnaStatus case final value?) 'qnaStatus': value,
      if (instance.questions?.map((e) => e.toJson()).toList() case final value?)
        'questions': value,
    };
