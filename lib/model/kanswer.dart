import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kanswer.g.dart';

@JsonSerializable()
class KAnswer {
  static const String QA_ID = "qaID";
  static const String QUESTION_ID = "questionID";
  static const String ANSWER_ID = "answerID";
  static const String TEXT = "text"; // qa | lesson
  static const String IS_CORRECT = "isCorrect";
  static const String MEDIA_URL = "mediaURL"; // cover
  static const String MEDIA_TYPE = "mediaType"; // image | video
  static const String CORRECT_ANSWER = "correctAnswer"; // Y | N
  static const String BUTTON_COLOR = "buttonColor";
  static const String BUTTON_STYLE = "buttonStyle"; // IN | OUT

  @JsonKey(name: QA_ID)
  String? qaID;

  @JsonKey(name: QUESTION_ID)
  String? questionID;

  @JsonKey(name: ANSWER_ID)
  String? answerID;

  @JsonKey(name: TEXT)
  String? text;

  @JsonKey(name: IS_CORRECT, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isCorrect;

  @JsonKey(name: MEDIA_URL)
  String? mediaURL;

  @JsonKey(name: MEDIA_TYPE)
  String? mediaType;

  @JsonKey(name: CORRECT_ANSWER)
  String? correctAnswer;

  @JsonKey(name: BUTTON_COLOR)
  String? buttonColor;

  @JsonKey(name: BUTTON_STYLE)
  String? buttonStyle;

  /// Methods
  @override
  int get hashCode => (this.answerID ?? "").hashCode;

  @override
  bool operator ==(Object other) => this.hashCode == other.hashCode;

  // JSON
  KAnswer();

  factory KAnswer.fromJson(Map<String, dynamic> json) =>
      _$KAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$KAnswerToJson(this);
}
