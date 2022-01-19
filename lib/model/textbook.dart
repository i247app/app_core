import 'package:app_core/model/chapter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'textbook.g.dart';

@JsonSerializable()
class Textbook {
  static const String TEXTBOOK_ID = "textbookID";
  static const String COURSE_ID = "courseID";
  static const String TITLE = "title";
  static const String CATEGORY = "category";
  static const String CHAPTER_NUMBER = "chapterNumber";
  static const String SUBTITLE = "subtitle";
  static const String TEXT = "text";
  static const String MEDIA_URL = "mediaURL"; // cover
  static const String MEDIA_TYPE = "mediaType"; // image | video
  static const String TEXTBOOK_STATUS = "textbookStatus";
  static const String LEVEL = "level";
  static const String GRADE = "grade";
  static const String TAGS = "tags";
  static const String CHAPTERS = "chapters";

  @JsonKey(name: TEXTBOOK_ID)
  String? textbookID;

  @JsonKey(name: COURSE_ID)
  String? courseID;

  @JsonKey(name: TITLE)
  String? title;

  @JsonKey(name: CATEGORY)
  String? category;

  @JsonKey(name: CHAPTER_NUMBER)
  String? chapterNumber;

  @JsonKey(name: SUBTITLE)
  String? subtitle;

  @JsonKey(name: TEXT)
  String? text;

  @JsonKey(name: MEDIA_URL)
  String? mediaURL;

  @JsonKey(name: MEDIA_TYPE)
  String? mediaType;

  @JsonKey(name: TEXTBOOK_STATUS)
  String? textbookStatus;

  @JsonKey(name: LEVEL)
  String? level;

  @JsonKey(name: GRADE)
  String? grade;

  @JsonKey(name: TAGS)
  String? tags;

  @JsonKey(name: CHAPTERS)
  List<Chapter>? chapters;

  // JSON
  Textbook();

  factory Textbook.fromJson(Map<String, dynamic> json) =>
      _$TextbookFromJson(json);

  Map<String, dynamic> toJson() => _$TextbookToJson(this);
}
