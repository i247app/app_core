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
  static const String BUDDY = "buddy";
  static const String TEACHER = "teacher";
  static const String EXPERT = "expert";
  static const String ONLINE = "online";
  static const String IN_PERSON = "inPerson";

  static const int OFF = -1;
  static const int ON = 0;
  static const int READONLY = 1;

  @JsonKey(name: HOMEWORK, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? homework;

  @JsonKey(name: HEADSTART, toJson: zzz_itoa, fromJson: zzz_gigNavTryAtoi)
  int? headstart;

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

  // JSON
  KGigNav();

  factory KGigNav.fromJson(Map<String, dynamic> json) =>
      _$KGigNavFromJson(json);

  Map<String, dynamic> toJson() => _$KGigNavToJson(this);
}
