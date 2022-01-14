import 'package:app_core/app_core.dart';
import 'package:app_core/model/lop_schedule.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_lop_schedules_response.g.dart';

@JsonSerializable()
class GetLopSchedulesResponse extends BaseResponse {
  @JsonKey(name: "lopSchedules")
  List<LopSchedule>? schedules;

  // JSON
  GetLopSchedulesResponse();

  factory GetLopSchedulesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetLopSchedulesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetLopSchedulesResponseToJson(this);
}
