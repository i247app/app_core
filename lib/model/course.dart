import 'package:app_core/model/kobject.dart';
import 'package:app_core/model/textbook.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/response/base_response.dart';

part 'course.g.dart';

@JsonSerializable()
class Course extends KObject {
  static const String COURSE_ID = "courseID";
  static const String COURSE_TYPE = "courseType";
  static const String TITLE = "title";
  static const String SUBTITLE = "subtitle";
  static const String TEXT = "text";
  static const String MEDIA_URL = "mediaURL";
  static const String MEDIA_TYPE = "mediaType";
  static const String PROVIDER_ID = "providerID";
  static const String PROVIDER_NAME = "providerName";
  static const String COURSE_STATUS = "courseStatus"; // linked xrefs
  static const String LEVEL = "level";
  static const String GRADE = "grade";
  static const String TAGS = "tags";
  static const String TEXTBOOKS = "lopTextbooks"; // linked xrefs

  static const String TYPE_EDU = "EDU";
  static const String TYPE_CERT = "CERT";
  static const String TYPE_NON = "NON";

  @JsonKey(name: COURSE_ID)
  String? courseID;

  @JsonKey(name: COURSE_TYPE)
  String? courseType;

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

  @JsonKey(name: PROVIDER_ID)
  String? providerID;

  @JsonKey(name: PROVIDER_NAME)
  String? providerName;

  @JsonKey(name: COURSE_STATUS)
  String? courseStatus;

  @JsonKey(name: LEVEL)
  String? level;

  @JsonKey(name: GRADE)
  String? grade;

  @JsonKey(name: TAGS)
  String? tags;

  @JsonKey(name: TEXTBOOKS)
  List<Textbook>? textbooks;

  // JSON
  Course();

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
