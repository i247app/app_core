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
      ..studentID = user.puid;
  }

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
