import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kmath_helper.dart';
import 'package:app_core/model/course.dart';
import 'package:app_core/model/kstudent.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/textbook.dart';

part 'lop.g.dart';

@JsonSerializable()
class Lop extends Course {
  static const String LOP_ID = "lopID";
  static const String CAPACITY = "capacity";
  static const String COUNT = "count";
  static const String LOP_STATUS = "lopStatus";
  static const String START_DATE = "startDate";
  static const String END_DATE = "endDate";
  static const String LOP_SCHEDULES = "lopSchedules"; // linked xrefs
  static const String LOP_INSTRUCTORS = "lopInstructors"; // linked xrefs
  static const String LOP_ASSISTANTS = "lopAssistants"; // linked xrefs
  static const String LOP_ENROLLMENTS = "lopEnrollments"; // linked xrefs
  static const String LOP_STUDENTS = "lopStudents";

  @JsonKey(name: LOP_ID)
  String? lopID;

  @JsonKey(name: CAPACITY)
  String? capacity;

  @JsonKey(name: COUNT)
  String? count;

  @JsonKey(name: LOP_STATUS)
  String? lopStatus;

  @JsonKey(name: START_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? startDate;

  @JsonKey(name: END_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? endDate;

  @JsonKey(name: LOP_STUDENTS)
  List<KStudent>? students;

  @JsonKey(name: LOP_INSTRUCTORS)
  List<Tutor>? instructors;

  /// Methods
  @JsonKey(ignore: true)
  bool get isUnlimitedCapacity => KMathHelper.parseInt(this.capacity) == -1;

  @JsonKey(ignore: true)
  Tutor get theInstructor => this.instructors!.first;

  // JSON
  Lop();

  factory Lop.fromJson(Map<String, dynamic> json) => _$LopFromJson(json);

  Map<String, dynamic> toJson() => _$LopToJson(this);
}
