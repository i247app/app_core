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
  static const String ONLINE_MODE = "onlineMode";

  static const String IS_IN_PERSON = "isInPerson";
  static const String IS_HEADSTART = "isHeadstart";
  static const String IS_ENGLISH = "isEnglish";

  static const String GIG_COUNT = "gigCount";

  static const String STATUS_PENDING = "P";
  static const String STATUS_ACTIVE = "A";
  static const String STATUS_ALERT = "K";
  static const String STATUS_ONLINE = "T";
  static const String STATUS_BLOCK = "B";

  static const String ACTION_PENDING = "PENDING";
  static const String ACTION_ACTIVATE = "ACTIVATE";
  static const String ACTION_ALERT = "ALERT";
  static const String ACTION_OFFLINE = "OFFLINE";
  static const String ACTION_IN_PERSON = "IN_PERSON";
  static const String ACTION_HEADSTART = "HEADSTART";
  static const String ACTION_ENGLISH = "ENGLISH";

  static const String IS_PREFER = "isPrefer";
  static const String IS_GENIUS = "isGenius";
  static const String IS_KEEP_WORKER = "isKeepWorker";

  @JsonKey(name: "rating")
  Review? review;

  @JsonKey(name: TUTOR_ID)
  String? tutorID;

  @JsonKey(name: GIG_COUNT)
  String? gigCount;

  @JsonKey(name: IS_ONLINE)
  bool? isOnline;

  @JsonKey(name: ONLINE_MODE, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? onlineMode;

  @JsonKey(name: IS_IN_PERSON)
  bool? isInPerson;

  @JsonKey(name: IS_HEADSTART)
  bool? isHeadstart;

  @JsonKey(name: IS_ENGLISH)
  bool? isEnglish;

  @JsonKey(name: IS_PREFER)
  bool? isPrefer;

  @JsonKey(name: IS_GENIUS)
  bool? isGenius;

  @JsonKey(name: IS_KEEP_WORKER)
  bool? isKeepWorker;

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
      return (isPrefer ?? false)
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
      return (isPrefer ?? false)
          ? Icons.diamond_outlined
          : (isGenius ?? false)
              ? Icons.local_police_outlined
              : Icons.verified_user_outlined;
    } else {
      return Icons.gpp_maybe_outlined;
    }
  }

  double get highlightSize => isGenius != true || isPrefer != true ? 10.0 : 1.0;

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
