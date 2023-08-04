// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_problem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyProblem _$StudyProblemFromJson(Map<String, dynamic> json) => StudyProblem()
  ..grade = json['GRADE'] as String?
  ..subject = json['SUBJECT'] as String?
  ..topic = json['TOPIC'] as String?
  ..skill = json['SKILL'] as int?
  ..difficulty = json['DIFFICULTY'] as int?
  ..promptImage = json['PROMPT_IMAGE'] as String?
  ..promptImageText = json['PROMPT_IMAGE_TEXT'] as String?
  ..promptText = json['PROMPT_TEXT'] as String?
  ..promptLanguage = json['PROMPT_LANGUAGE'] as String?
  ..choice1 = json['CHOICE1'] as String?
  ..choice2 = json['CHOICE2'] as String?
  ..choice3 = json['CHOICE3'] as String?
  ..choice4 = json['CHOICE4'] as String?;

Map<String, dynamic> _$StudyProblemToJson(StudyProblem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('GRADE', instance.grade);
  writeNotNull('SUBJECT', instance.subject);
  writeNotNull('TOPIC', instance.topic);
  writeNotNull('SKILL', instance.skill);
  writeNotNull('DIFFICULTY', instance.difficulty);
  writeNotNull('PROMPT_IMAGE', instance.promptImage);
  writeNotNull('PROMPT_IMAGE_TEXT', instance.promptImageText);
  writeNotNull('PROMPT_TEXT', instance.promptText);
  writeNotNull('PROMPT_LANGUAGE', instance.promptLanguage);
  writeNotNull('CHOICE1', instance.choice1);
  writeNotNull('CHOICE2', instance.choice2);
  writeNotNull('CHOICE3', instance.choice3);
  writeNotNull('CHOICE4', instance.choice4);
  return val;
}
