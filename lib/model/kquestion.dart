import 'package:json_annotation/json_annotation.dart';

part 'kquestion.g.dart';

@JsonSerializable()
class KQuestion {
  @JsonKey(name: "pid")
  String? pid;

  @JsonKey(name: "question")
  String? question;

  @JsonKey(name: "answer")
  int? answer;

  // JSON
  KQuestion();

  factory KQuestion.fromJson(Map<String, dynamic> json) => _$KQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$KQuestionToJson(this);
}
