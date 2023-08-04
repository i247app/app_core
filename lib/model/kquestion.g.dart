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
  writeNotNull('text', instance.text);
  writeNotNull('mediaURL', instance.mediaURL);
  writeNotNull('mediaType', instance.mediaType);
  writeNotNull('tags', instance.tags);
  writeNotNull('answers', instance.answers?.map((e) => e.toJson()).toList());
  writeNotNull('isGenAnswer', zzz_bool2Str(instance.isGenAnswer));
  return val;
}
