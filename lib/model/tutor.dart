import 'package:app_core/model/review.dart';
import 'package:app_core/model/user_tag.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/app_core.dart';
import 'package:app_core/model/keducation.dart';
import 'package:app_core/model/kaddress.dart';

part 'tutor.g.dart';

@JsonSerializable()
class Tutor extends KUser {
  static const String TUTOR_ID = "tutorID";
  static const String IS_ONLINE = "isOnline";

  static const String CAN_IN_PERSON = "canInPerson";
  static const String CAN_HEADSTART = "canHeadstart";
  static const String CAN_ENGLISH = "canEnglish";
  static const String CAN_VIET = "canViet";

  static const String STATUS_PENDING = "P";
  static const String STATUS_ACTIVE = "A";
  static const String STATUS_ALERT = "K";
  static const String STATUS_ONLINE = "T";
  static const String STATUS_BLOCK = "B";

  static const String ACTION_PENDING = "PENDING";
  static const String ACTION_ACTIVATE = "ACTIVATE";
  static const String ACTION_ALERT = "ALERT";
  static const String ACTION_OFFLINE = "OFFLINE";
  static const String ACTION_FORCE_OFFLINE = "FORCE_OFFLINE";
  static const String ACTION_CAN_IN_PERSON = "CAN_IN_PERSON";
  static const String ACTION_CAN_ONLINE = "CAN_ONLINE";
  static const String ACTION_CAN_HEADSTART = "CAN_HEADSTART";
  static const String ACTION_CAN_ENGLISH = "CAN_ENGLISH";
  static const String ACTION_CAN_VIET = "CAN_VIET";

  static const String IS_SKILL = "isSkill";
  static const String IS_GENIUS = "isGenius";
  static const String IS_KEEP_WORKER = "isKeepWorker";
  static const String IS_BLOCK_WORKER = "isBlockWorker";

  @JsonKey(name: "rating")
  Review? review;

  @JsonKey(name: TUTOR_ID)
  String? tutorID;

  @JsonKey(name: IS_ONLINE, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isOnline;

  @JsonKey(name: CAN_IN_PERSON, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? canInPerson;

  @JsonKey(name: CAN_HEADSTART, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? canHeadstart;

  @JsonKey(name: CAN_ENGLISH, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? canEnglish;

  @JsonKey(name: CAN_VIET, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? canViet;

  @JsonKey(name: IS_SKILL, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isSkill;

  @JsonKey(name: IS_GENIUS, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isGenius;

  @JsonKey(name: IS_KEEP_WORKER)
  bool? isKeepWorker;

  @JsonKey(name: IS_BLOCK_WORKER)
  bool? isBlockWorker;

  @JsonKey(name: "tutorStatus")
  String? tutorStatus;

  @JsonKey(name: "userType")
  String? userType;

  @JsonKey(name: "userTags")
  List<UserTag>? userTags;

  @JsonKey(name: "activeDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? activeDate;

  @JsonKey(name: "tutorJoinDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? tutorJoinDate;

  @JsonKey(name: "mathLevelMin")
  String? mathLevelMin;

  @JsonKey(name: "mathLevelMax")
  String? mathLevelMax;

  @JsonKey(name: "vietLevelMin")
  String? vietLevelMin;

  @JsonKey(name: "vietLevelMax")
  String? vietLevelMax;

  @JsonKey(name: "englishLevelMin")
  String? englishLevelMin;

  @JsonKey(name: "englishLevelMax")
  String? englishLevelMax;

  @JsonKey(name: "canOnline", fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? canOnline;

  @JsonKey(name: "subjects")
  List<String>? subjects;

  Color get highlightColor {
    return Colors.white;
    // if (userStatus == STATUS_BLOCK) {
    //   return Colors.white;
    // } else if (userStatus == STATUS_PENDING) {
    //   return Colors.white;
    // } else if (userStatus == STATUS_ACTIVE) {
    //   return (isPrefer ?? false)
    //       ? Colors.blue
    //       : (isGenius ?? false)
    //           ? Colors.white
    //           : Colors.green;
    // } else {
    //   return Colors.white;
    // }
  }

  Color? get iconColor {
    if (userStatus == STATUS_BLOCK) {
      return Colors.red;
    } else if (userStatus == STATUS_PENDING) {
      return Colors.orange;
    } else if (userStatus == STATUS_ACTIVE) {
      return (isSkill ?? false)
          ? Colors.blue
          : (isGenius ?? false)
              ? Colors.green
              : Colors.green;
    } else {
      return Colors.red;
    }
  }

  IconData? get icon {
    if (userStatus == STATUS_BLOCK) {
      return Icons.gpp_bad_outlined;
    } else if (userStatus == STATUS_PENDING) {
      return Icons.gpp_maybe_outlined;
    } else if (userStatus == STATUS_ACTIVE) {
      return (isSkill ?? false)
          ? Icons.diamond_outlined
          : (isGenius ?? false)
              ? Icons.local_police_outlined
              : Icons.verified_user_outlined;
    } else {
      return Icons.gpp_maybe_outlined;
    }
  }

  double get highlightSize => isGenius != true || isSkill != true ? 10.0 : 1.0;

  /// Getters
  @JsonKey(ignore: true)
  bool get requiresEdit =>
      (this.userTags ?? []).isEmpty ||
      (this.educations ?? []).isEmpty ||
      KStringHelper.isEmpty(this.officialIDURL);

  // JSON
  Tutor();

  factory Tutor.fromJson(Map<String, dynamic> json) => _$TutorFromJson(json);

  Map<String, dynamic> toJson() => _$TutorToJson(this);
}
