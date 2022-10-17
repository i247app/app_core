import 'package:app_core/app_core.dart';
import 'package:app_core/model/lop.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/textbook.dart';
import 'package:app_core/model/student.dart';

part 'lop_schedule.g.dart';

@JsonSerializable()
class LopSchedule extends Lop {
  static const String LOP_SCHEDULE_ID = "scheduleID";
  static const String START_TIME = "startTime";
  static const String END_TIME = "endTime";
  static const String LOP_SCHEDULE_STATUS = "scheduleStatus";

  @JsonKey(name: LOP_SCHEDULE_ID)
  String? lopScheduleID;

  @JsonKey(name: START_TIME, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? startTime; // date with time

  @JsonKey(name: END_TIME, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? endTime; // date with time

  @JsonKey(name: LOP_SCHEDULE_STATUS)
  String? lopScheduleStatus;

  /// Methods
  @JsonKey(ignore: true)
  bool get isJoined {
    try {
      return this
              .students
              ?.map((s) => s.puid)
              .contains(KSessionData.me!.puid) ??
          false;
    } catch (_) {
      return false;
    }
  }

  // JSON
  LopSchedule();

  factory LopSchedule.fromJson(Map<String, dynamic> json) =>
      _$LopScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$LopScheduleToJson(this);
}
