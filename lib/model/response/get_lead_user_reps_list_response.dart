import 'package:app_core/app_core.dart';
import 'package:app_core/model/klead.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_lead_user_reps_list_response.g.dart';

@JsonSerializable()
class KGetLeadUserRepsListResponse extends BaseResponse {
  @JsonKey(name: "reps")
  List<KUser>? reps;

  // JSON
  KGetLeadUserRepsListResponse();

  factory KGetLeadUserRepsListResponse.fromJson(Map<String, dynamic> json) =>
      _$KGetLeadUserRepsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KGetLeadUserRepsListResponseToJson(this);
}
