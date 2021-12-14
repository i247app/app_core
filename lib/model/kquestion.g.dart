// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kquestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KQuestion _$KQuestionFromJson(Map<String, dynamic> json) => KQuestion()
  ..qaID = json['qaID'] as String?
  ..questionID = json['questionID'] as String?
  ..questionType = json['questionType'] as String?
  ..questionText = json['questionText'] as String?
  ..mediaURL = json['mediaURL'] as String?
  ..mediaType = json['mediaType'] as String?
  ..answers = (json['answers'] as List<dynamic>?)
      ?.map((e) => KAnswer.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$KQuestionToJson(KQuestion instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('qaID', instance.qaID);
  writeNotNull('questionID', instance.questionID);
  writeNotNull('questionType', instance.questionType);
  writeNotNull('questionText', instance.questionText);
  writeNotNull('mediaURL', instance.mediaURL);
  writeNotNull('mediaType', instance.mediaType);
  writeNotNull('answers', instance.answers?.map((e) => e.toJson()).toList());
  return val;
}
