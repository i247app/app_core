import 'dart:math';

import 'package:app_core/app_core.dart';
import 'package:app_core/model/kanswer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kquestion.g.dart';

@JsonSerializable()
class KQuestion {
  static const String QA_ID = "qaID";
  static const String QUESTION_ID = "questionID";
  static const String QUESTION_TYPE = "questionType"; // MULT | WRITTEN
  static const String TEXT = "text";
  static const String MEDIA_URL = "mediaURL"; // kquestion image or video
  static const String MEDIA_TYPE = "mediaType"; // image | video
  static const String ANSWERS = "answers";
  static const String REVIEWS = "reviews";
  static const String IS_GEN_ANSWER = "isGenAnswer";

  static const String MEDIA_TYPE_TEXT = "text";
  static const String MEDIA_TYPE_IMAGE = "image";
  static const String MEDIA_TYPE_VIDEO = "video";

  @JsonKey(name: QA_ID)
  String? qaID;

  @JsonKey(name: QUESTION_ID)
  String? questionID;

  @JsonKey(name: QUESTION_TYPE)
  String? questionType;

  @JsonKey(name: TEXT)
  String? text;

  @JsonKey(name: MEDIA_URL)
  String? mediaURL;

  @JsonKey(name: MEDIA_TYPE)
  String? mediaType; // image | video

  @JsonKey(name: ANSWERS)
  List<KAnswer>? answers;

  @JsonKey(name: IS_GEN_ANSWER, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isGenAnswer;

  @JsonKey(ignore: true)
  KAnswer? get correctAnswer =>
      (this.answers ?? []).firstWhere((a) => a.isCorrect ?? false);

  List<KAnswer> generateAnswers([int count = 4, String? answerType]) {
    try {
      if (answerType == 'letter') {
        final correct = correctAnswer?.text ?? "";
        if (!KStringHelper.isExist(correct)) {
          throw Exception();
        }

        final answerValues = [correct];

        // Generate unique random values
        while (answerValues.length < count) {
          final letter = KUtil.generateRandomString(1);
          if (!answerValues.contains(letter)) {
            answerValues.add(letter);
          }
        }

        return (answerValues..shuffle())
            .map((av) => KAnswer()
              ..text = av.toString()
              ..isCorrect = correct == av)
            .toList();
      } else if (answerType == 'word') {
        final correct = correctAnswer?.text ?? "";
        if (!KStringHelper.isExist(correct)) {
          throw Exception();
        }

        final answerValues = correct.split("");
        count = (answerValues.length * 2.5).ceil();

        // Generate unique random values
        while (answerValues.length < count) {
          final letter = KUtil.generateRandomString(1);
          if (!answerValues.contains(letter)) {
            answerValues.add(letter);
          }
        }

        return answerValues
            .map((av) => KAnswer()
              ..text = av.toString()
              ..isCorrect = correct.contains(av))
            .toList();
      } else {
        final correct = int.tryParse(correctAnswer?.text ?? "");
        if (correct == null) {
          throw Exception();
        }

        final random = Random();
        final answerValues = [correct];

        // Generate unique random values
        while (answerValues.length < count) {
          final number = random.nextInt(10);
          if (!answerValues.contains(number)) {
            answerValues.add(number);
          }
        }

        return (answerValues..shuffle())
            .map((av) => KAnswer()
              ..text = av.toString()
              ..isCorrect = correct == av)
            .toList();
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // JSON
  KQuestion();

  factory KQuestion.fromJson(Map<String, dynamic> json) =>
      _$KQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$KQuestionToJson(this);
}
