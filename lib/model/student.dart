import 'package:app_core/model/review.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/app_core.dart';
import 'package:app_core/model/keducation.dart';
import 'package:app_core/model/kaddress.dart';

part 'student.g.dart';

@JsonSerializable()
class Student extends KUser {
  static const String LINK_STATUS_ACTIVE = "A";
  static const String LINK_STATUS_DISABLE = "D";
  static const List<List> GRADE_LEVELS = [
    [00, 'Mẫu Giáo'],
    [01, 'Lớp 1'],
    [02, 'Lớp 2'],
    [03, 'Lớp 3'],
    [04, 'Lớp 4'],
    [05, 'Lớp 5'],
    [06, 'Lớp 6'],
    [07, 'Lớp 7'],
    [08, 'Lớp 8'],
    [09, 'Lớp 9'],
    [10, 'Lớp 10'],
    [11, 'Lớp 11'],
    [12, 'Lớp 12'],
    [13, 'Đại Học'],
  ];

  @JsonKey(name: "startDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? startDate;

  @JsonKey(name: "endDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? endDate;

  @JsonKey(name: "rating")
  Review? review;

  @JsonKey(name: "studentID")
  String? studentID;

  @JsonKey(name: "shortText")
  String? shortText;

  /// Methods
  static String gradeLevelToWord(int gradeLevel) =>
      GRADE_LEVELS[gradeLevel][1] as String;

  @JsonKey(ignore: true)
  String get prettyGradeLevel => gradeLevelToWord(int.parse(gradeLevel ?? "0"));

  // JSON
  Student();

  factory Student.fromKUser(KUser user) {
    return Student()
      ..puid = user.puid
      ..kunm = user.kunm
      ..phone = user.phone
      ..phoneCode = user.phoneCode
      ..fullAddress = user.fullAddress
      ..email = user.email
      ..firstName = user.firstName
      ..middleName = user.middleName
      ..lastName = user.lastName
      ..dob = user.dob
      ..parentName = user.parentName
      ..parentEmail = user.parentEmail
      ..parentPhone = user.parentPhone
      ..address1 = user.address1
      ..address2 = user.address2
      ..city = user.city
      ..linkStatus = user.linkStatus
      ..studentID = user.puid;
  }

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
