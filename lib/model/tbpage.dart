import 'package:app_core/model/kquestion.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tbpage.g.dart';

@JsonSerializable()
class TBPage {
  static const String PAGE_ID = "pageID";
  static const String CHAPTER_ID = "chapterID";
  static const String TEXTBOOK_ID = "textbookID";
  static const String INDEX = "index";
  static const String TITLE = "title";
  static const String SUBTITLE = "subtitle";
  static const String TEXT = "text";
  static const String MEDIA_URL = "mediaURL"; // cover
  static const String MEDIA_TYPE = "mediaType"; // image | video
  static const String PAGE_STATUS = "pageStatus";
  static const String QUESTION_ID = "questionID";
  static const String QUESTIONS = "questions";

  @JsonKey(name: PAGE_ID)
  String? pageID;

  @JsonKey(name: CHAPTER_ID)
  String? chapterID;

  @JsonKey(name: TEXTBOOK_ID)
  String? textbookID;

  @JsonKey(name: INDEX)
  String? index;

  @JsonKey(name: TITLE)
  String? title;

  @JsonKey(name: SUBTITLE)
  String? subtitle;

  @JsonKey(name: TEXT)
  String? text;

  @JsonKey(name: MEDIA_URL)
  String? mediaURL;

  @JsonKey(name: MEDIA_TYPE)
  String? mediaType;

  @JsonKey(name: PAGE_STATUS)
  String? pageStatus;

  @JsonKey(name: QUESTION_ID)
  String? questionID;

  @JsonKey(name: QUESTIONS)
  List<KQuestion>? questions;

  @JsonKey(ignore: true)
  KQuestion? get theQuestion =>
      (this.questions ?? []).isNotEmpty ? this.questions!.first : null;

  // JSON
  TBPage();

  factory TBPage.fromJson(Map<String, dynamic> json) => _$TBPageFromJson(json);

  Map<String, dynamic> toJson() => _$TBPageToJson(this);
}
