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

Map<String, dynamic> _$KAnswerToJson(KAnswer instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('qaID', instance.qaID);
  writeNotNull('questionID', instance.questionID);
  writeNotNull('answerID', instance.answerID);
  writeNotNull('text', instance.text);
  writeNotNull('isCorrect', zzz_bool2Str(instance.isCorrect));
  writeNotNull('mediaURL', instance.mediaURL);
  writeNotNull('mediaType', instance.mediaType);
  writeNotNull('correctAnswer', instance.correctAnswer);
  writeNotNull('buttonColor', instance.buttonColor);
  writeNotNull('buttonStyle', instance.buttonStyle);
  return val;
}
