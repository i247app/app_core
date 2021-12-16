import 'dart:math';

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

  @JsonKey(ignore: true)
  KAnswer? get correctAnswer =>
      (this.answers ?? []).firstWhere((a) => a.isCorrect ?? false);

  List<KAnswer>? getAnswers() {
    if (this.correctAnswer == null) {
      return [];
    }
    final correct = int.tryParse(this.correctAnswer!.text ?? "0");

    var list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        .where((element) => correct != element)
        .toList();

    var random = new Random();
    var anwers = List<KAnswer>.generate(3, (index) {
      var r = random.nextInt(list.length);
      var item = list[r];
      list.removeAt(r);
      return KAnswer()
        ..isCorrect = false
        ..text = item.toString();
    });
    anwers.add(this.correctAnswer!);
    anwers.shuffle();
    return anwers;
  }

  // JSON
  KQuestion();

  factory KQuestion.fromJson(Map<String, dynamic> json) =>
      _$KQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$KQuestionToJson(this);
}
