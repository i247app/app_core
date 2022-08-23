import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/app_core.dart';

part 'study_problem.g.dart';

enum ProblemType { text, image }

@JsonSerializable()
class StudyProblem {
  @JsonKey(name: "GRADE")
  String? grade;

  @JsonKey(name: "SUBJECT")
  String? subject;

  @JsonKey(name: "TOPIC")
  String? topic;

  @JsonKey(name: "SKILL")
  int? skill;

  @JsonKey(name: "DIFFICULTY")
  int? difficulty;

  @JsonKey(name: "PROMPT_IMAGE")
  String? promptImage;

  @JsonKey(name: "PROMPT_IMAGE_TEXT")
  String? promptImageText;

  @JsonKey(name: "PROMPT_TEXT")
  String? promptText;

  // perhaps, PROMPT_TEXT_LANGUAGE and PROMPT_IMAGE_TEXT_LANGUAGE
  @JsonKey(name: "PROMPT_LANGUAGE")
  String? promptLanguage;

  // @JsonKey(name: "PROMPT_AUDIO_TTS")
  // String promptAudioTTS;

  @JsonKey(name: "CHOICE1")
  String? choice1;

  @JsonKey(name: "CHOICE2")
  String? choice2;

  @JsonKey(name: "CHOICE3")
  String? choice3;

  @JsonKey(name: "CHOICE4")
  String? choice4;

  // Getters
  @JsonKey(ignore: true)
  String? get answer => choice1;

  @JsonKey(ignore: true)
  ProblemType? get type {
    if (this.promptImage != null)
      return ProblemType.image;
    else if (this.promptText != null)
      return ProblemType.text;
    else
      return null;
  }

  @JsonKey(ignore: true)
  String? get prompt {
    switch (this.type) {
      case ProblemType.image:
        return this.promptImage;
      case ProblemType.text:
        return this.promptText;
      default:
        return null;
    }
  }

  @JsonKey(ignore: true)
  List<String?> get randomizedChoices {
    final l = [choice1, choice2, choice3, choice4];
    l.sort((a, b) => KUtil.getRandom().nextInt(20) - 10);
    print(l);
    return l;
  }

  // JSON
  StudyProblem();

  factory StudyProblem.fromJson(Map<String, dynamic> json) =>
      _$StudyProblemFromJson(json);

  Map<String, dynamic> toJson() => _$StudyProblemToJson(this);
}
