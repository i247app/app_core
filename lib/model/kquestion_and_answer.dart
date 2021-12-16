import 'dart:math';

import 'package:app_core/model/kanswer.dart';
import 'package:app_core/model/kquestion.dart';
import 'package:json_annotation/json_annotation.dart';

import 'kquestion.dart';
part 'kquestion_and_answer.g.dart';

@JsonSerializable()
class KQuestionAndAnswer {
  static const String QNA_ID = "qnaID";
  static const String QNA_TYPE = "qnaType";
  static const String TITLE = "title"; // MULT | WRITTEN
  static const String SUBTITLE = "subtitle";
  static const String TEXT = "text"; // kquestion image or video
  static const String MEDIA_URL = "mediaURL"; // image | video
  static const String MEDIA_TYPE = "mediaType";
  static const String QNASTATUS = "qnaStatus";
  static const String QUESTIONS = "questions";

  static const String MEDIA_TYPE_TEXT = "text";
  static const String MEDIA_TYPE_IMAGE = "image";
  static const String MEDIA_TYPE_VIDEO = "video";

  @JsonKey(name: QNA_ID)
  String? qnaID;

  @JsonKey(name: QNA_TYPE)
  String? qnaType;

  @JsonKey(name: TITLE)
  String? title;

  @JsonKey(name: SUBTITLE)
  String? subtitle;

  @JsonKey(name: TEXT)
  String? text;

  @JsonKey(name: MEDIA_URL)
  String? mediaURL;

  @JsonKey(name: MEDIA_TYPE)
  String? mediaType; // image | video

  @JsonKey(name: QNASTATUS)
  String? qnaStatus;

  @JsonKey(name: QUESTIONS)
  List<KQuestion>? questions;

  // JSON
  KQuestionAndAnswer();

  factory KQuestionAndAnswer.fromJson(Map<String, dynamic> json) =>
      _$KQuestionAndAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$KQuestionAndAnswerToJson(this);
}
