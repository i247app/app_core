// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_problem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyProblem _$StudyProblemFromJson(Map<String, dynamic> json) => StudyProblem()
  ..grade = json['GRADE'] as String?
  ..subject = json['SUBJECT'] as String?
  ..topic = json['TOPIC'] as String?
  ..skill = (json['SKILL'] as num?)?.toInt()
  ..difficulty = (json['DIFFICULTY'] as num?)?.toInt()
  ..promptImage = json['PROMPT_IMAGE'] as String?
  ..promptImageText = json['PROMPT_IMAGE_TEXT'] as String?
  ..promptText = json['PROMPT_TEXT'] as String?
  ..promptLanguage = json['PROMPT_LANGUAGE'] as String?
  ..choice1 = json['CHOICE1'] as String?
  ..choice2 = json['CHOICE2'] as String?
  ..choice3 = json['CHOICE3'] as String?
  ..choice4 = json['CHOICE4'] as String?;

Map<String, dynamic> _$StudyProblemToJson(StudyProblem instance) =>
    <String, dynamic>{
      if (instance.grade case final value?) 'GRADE': value,
      if (instance.subject case final value?) 'SUBJECT': value,
      if (instance.topic case final value?) 'TOPIC': value,
      if (instance.skill case final value?) 'SKILL': value,
      if (instance.difficulty case final value?) 'DIFFICULTY': value,
      if (instance.promptImage case final value?) 'PROMPT_IMAGE': value,
      if (instance.promptImageText case final value?)
        'PROMPT_IMAGE_TEXT': value,
      if (instance.promptText case final value?) 'PROMPT_TEXT': value,
      if (instance.promptLanguage case final value?) 'PROMPT_LANGUAGE': value,
      if (instance.choice1 case final value?) 'CHOICE1': value,
      if (instance.choice2 case final value?) 'CHOICE2': value,
      if (instance.choice3 case final value?) 'CHOICE3': value,
      if (instance.choice4 case final value?) 'CHOICE4': value,
    };
