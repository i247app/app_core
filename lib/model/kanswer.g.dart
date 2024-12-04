// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kanswer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KAnswer _$KAnswerFromJson(Map<String, dynamic> json) => KAnswer()
  ..qaID = json['qaID'] as String?
  ..questionID = json['questionID'] as String?
  ..answerID = json['answerID'] as String?
  ..text = json['text'] as String?
  ..isCorrect = zzz_str2Bool(json['isCorrect'] as String?)
  ..mediaURL = json['mediaURL'] as String?
  ..mediaType = json['mediaType'] as String?
  ..correctAnswer = json['correctAnswer'] as String?
  ..buttonColor = json['buttonColor'] as String?
  ..buttonStyle = json['buttonStyle'] as String?;

Map<String, dynamic> _$KAnswerToJson(KAnswer instance) => <String, dynamic>{
      if (instance.qaID case final value?) 'qaID': value,
      if (instance.questionID case final value?) 'questionID': value,
      if (instance.answerID case final value?) 'answerID': value,
      if (instance.text case final value?) 'text': value,
      if (zzz_bool2Str(instance.isCorrect) case final value?)
        'isCorrect': value,
      if (instance.mediaURL case final value?) 'mediaURL': value,
      if (instance.mediaType case final value?) 'mediaType': value,
      if (instance.correctAnswer case final value?) 'correctAnswer': value,
      if (instance.buttonColor case final value?) 'buttonColor': value,
      if (instance.buttonStyle case final value?) 'buttonStyle': value,
    };
