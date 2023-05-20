import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/app_core.dart';

part 'kgig_nav.g.dart';

// ignore: non_constant_identifier_names
int? zzz_gigNavTryAtoi(dynamic num) {
  try {
    return zzz_atoi(num?.toString()) ?? KGigNav.OFF;
  } catch (e) {
    return KGigNav.OFF;
  }
}

@JsonSerializable()
class KGigNav {
  static const String HOMEWORK = "homework";
  static const String HEADSTART = "headstart";
  static const String MON_ENGLISH = "monEnglish";
  static const String MON_VIET = "monViet";
  static const String MON_MATH = "monMath";

  static const String BUDDY = "buddy";
  static const String TEACHER = "teacher";
  static const String EXPERT = "expert";

  static const String ONLINE = "online";
  static const String IN_PERSON = "inPerson";

  static const String TUTORING = "tutoring";
  static const String EXAM = "exam";
  static const String ENGLISH = "chitEN";
  static const String VIET = "chitVN";

  static const int OFF = -1;
  static const int ON = 0;
  static const int READONLY = 1;

  @JsonKey(name: HOMEWORK, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? homework;

  @JsonKey(name: HEADSTART, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? headstart;

  @JsonKey(name: MON_ENGLISH, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? monEnglish;

  @JsonKey(name: MON_VIET, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? monViet;

  @JsonKey(name: MON_MATH, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? monMath;

  @JsonKey(name: BUDDY, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? buddy;

  @JsonKey(name: TEACHER, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? teacher;

  @JsonKey(name: EXPERT, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? expert;

  @JsonKey(name: ONLINE, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? online;

  @JsonKey(name: IN_PERSON, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? inPerson;

  @JsonKey(name: TUTORING, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? tutoring;

  @JsonKey(name: EXAM, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? exam;

  @JsonKey(name: ENGLISH, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? english;

  @JsonKey(name: VIET, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? viet;

  // JSON
  KGigNav();

  factory KGigNav.fromJson(Map<String, dynamic> json) =>
      _$KGigNavFromJson(json);

  Map<String, dynamic> toJson() => _$KGigNavToJson(this);
}
