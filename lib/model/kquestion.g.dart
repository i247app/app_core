// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kquestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KQuestion _$KQuestionFromJson(Map<String, dynamic> json) => KQuestion()
  ..qaID = json['qaID'] as String?
  ..questionID = json['questionID'] as String?
  ..questionType = json['questionType'] as String?
  ..text = json['text'] as String?
  ..mediaURL = json['mediaURL'] as String?
  ..mediaType = json['mediaType'] as String?
  ..tags = (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..answers = (json['answers'] as List<dynamic>?)
      ?.map((e) => KAnswer.fromJson(e as Map<String, dynamic>))
      .toList()
  ..isGenAnswer = zzz_str2Bool(json['isGenAnswer'] as String?);

Map<String, dynamic> _$KQuestionToJson(KQuestion instance) => <String, dynamic>{
      if (instance.qaID case final value?) 'qaID': value,
      if (instance.questionID case final value?) 'questionID': value,
      if (instance.questionType case final value?) 'questionType': value,
      if (instance.text case final value?) 'text': value,
      if (instance.mediaURL case final value?) 'mediaURL': value,
      if (instance.mediaType case final value?) 'mediaType': value,
      if (instance.tags case final value?) 'tags': value,
      if (instance.answers?.map((e) => e.toJson()).toList() case final value?)
        'answers': value,
      if (zzz_bool2Str(instance.isGenAnswer) case final value?)
        'isGenAnswer': value,
    };
