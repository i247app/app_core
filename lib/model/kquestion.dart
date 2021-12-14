import 'dart:math';

import 'package:app_core/model/kanswer.dart';
import 'package:json_annotation/json_annotation.dart';
part 'kquestion.g.dart';

@JsonSerializable()
class KQuestion {
  static const String QA_ID = "qaID";
  static const String QUESTION_ID = "questionID";
  static const String QUESTION_TYPE = "questionType"; // MULT | WRITTEN
  static const String QUESTION_TEXT = "questionText";
  static const String MEDIA_URL = "mediaURL"; // kquestion image or video
  static const String MEDIA_TYPE = "mediaType"; // image | video
  static const String ANSWERS = "answers";
  static const String REVIEWS = "reviews";

  static const String MEDIA_TYPE_TEXT = "text";
  static const String MEDIA_TYPE_IMAGE = "image";
  static const String MEDIA_TYPE_VIDEO = "video";

  @JsonKey(name: QA_ID)
  String? qaID;

  @JsonKey(name: QUESTION_ID)
  String? questionID;

  @JsonKey(name: QUESTION_TYPE)
  String? questionType;

  @JsonKey(name: QUESTION_TEXT)
  String? questionText;

  @JsonKey(name: MEDIA_URL)
  String? mediaURL;

  @JsonKey(name: MEDIA_TYPE)
  String? mediaType; // image | video

  @JsonKey(name: ANSWERS)
  List<KAnswer>? answers;

  @JsonKey(ignore: true)
  KAnswer? get correctAnswer =>
      (this.answers ?? []).firstWhere((a) => a.isCorrect ?? false);

  // JSON
  KQuestion();

  factory KQuestion.fromJson(Map<String, dynamic> json) =>
      _$KQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$KQuestionToJson(this);

  static List<KQuestion> questionsMockup() {
    final questions = [
      "1 + 1",
      "3 + 2",
      "4 - 1",
      "4 + 5",
      "2 x 1",
      "2 x 3",
      "1 + 2 - 1",
      "4 + 8 - 5",
      "1 x 2 + 3",
      "1 + 2 x 3",
    ];
    final answers = [
      2,
      5,
      3,
      9,
      2,
      6,
      2,
      7,
      5,
      7,
    ];

    final _random = new Random();
    return List.generate(questions.length, (indexQuestion) {
      final correctIndex = _random.nextInt(3);
      final correctAnswer = answers[indexQuestion];
      var list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      return KQuestion()
        ..questionID = "q${indexQuestion + 1}"
        ..questionText = questions[indexQuestion]
        ..answers = List.generate(4, (index) {
          final dummyAnswer = list.removeAt(_random.nextInt(list.length));
          return KAnswer()
            ..answerID = "a${index + 1}"
            ..text = index == correctIndex
                ? correctAnswer.toString()
                : dummyAnswer.toString()
            ..isCorrect = index == correctIndex;
        });
    });
  }
}
