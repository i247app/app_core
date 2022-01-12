import 'package:app_core/model/review.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/app_core.dart';
import 'package:app_core/model/keducation.dart';
import 'package:app_core/model/kaddress.dart';

part 'student.g.dart';

@JsonSerializable()
class Student extends KUser {
  @JsonKey(name: "startDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? startDate;

  @JsonKey(name: "endDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? endDate;

  @JsonKey(name: "rating")
  Review? review;

  @JsonKey(name: "studentID")
  String? studentID;

  // JSON
  Student();

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
