import 'package:app_core/model/tbpage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chapter.g.dart';

@JsonSerializable()
class Chapter {
  static const String CHAPTER_ID = "chapterID";
  static const String TEXTBOOK_ID = "textbookID";
  static const String TITLE = "title";
  static const String SUBTITLE = "subtitle";
  static const String TEXT = "text";
  static const String CHAPTER_NUMBER = "chapterNumber";
  static const String GRADE = "grade";
  static const String MEDIA_URL = "mediaURL"; // cover
  static const String MEDIA_TYPE = "mediaType"; // image | video
  static const String CHAPTER_STATUS = "chapterStatus";
  static const String PAGES = "pages";

  @JsonKey(name: CHAPTER_ID)
  String? chapterID;

  @JsonKey(name: TEXTBOOK_ID)
  String? textbookID;

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

  @JsonKey(name: CHAPTER_STATUS)
  String? chapterStatus;

  @JsonKey(name: PAGES)
  List<TBPage>? pages;

  @JsonKey(name: CHAPTER_NUMBER)
  String? chapterNumber;

  @JsonKey(name: GRADE)
  String? grade;

  // JSON
  Chapter();

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}
