// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kquestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KQuestion _$KQuestionFromJson(Map<String, dynamic> json) => KQuestion()
  ..pid = json['pid'] as String?
  ..question = json['question'] as String?
  ..answer = json['answer'] as int?;

Map<String, dynamic> _$KQuestionToJson(KQuestion instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('pid', instance.pid);
  writeNotNull('question', instance.question);
  writeNotNull('answer', instance.answer);
  return val;
}
