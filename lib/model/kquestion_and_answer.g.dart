// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kquestion_and_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KQuestionAndAnswer _$KQuestionAndAnswerFromJson(Map<String, dynamic> json) =>
    KQuestionAndAnswer()
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

Map<String, dynamic> _$KQuestionAndAnswerToJson(KQuestionAndAnswer instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('qnaID', instance.qnaID);
  writeNotNull('qnaType', instance.qnaType);
  writeNotNull('title', instance.title);
  writeNotNull('subtitle', instance.subtitle);
  writeNotNull('text', instance.text);
  writeNotNull('mediaURL', instance.mediaURL);
  writeNotNull('mediaType', instance.mediaType);
  writeNotNull('qnaStatus', instance.qnaStatus);
  writeNotNull(
      'questions', instance.questions?.map((e) => e.toJson()).toList());
  return val;
}
