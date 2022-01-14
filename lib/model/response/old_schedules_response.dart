import 'package:app_core/app_core.dart';
import 'package:app_core/model/lop_schedule.dart';
import 'package:json_annotation/json_annotation.dart';

part 'old_schedules_response.g.dart';

@JsonSerializable()
class OldSchedulesResponse extends BaseResponse {
  @JsonKey(name: "courses")
  List<LopSchedule>? schedules;

  // JSON
  OldSchedulesResponse();

  factory OldSchedulesResponse.fromJson(Map<String, dynamic> json) =>
      _$OldSchedulesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OldSchedulesResponseToJson(this);
}
