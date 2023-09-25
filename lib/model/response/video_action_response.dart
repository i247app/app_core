import 'package:app_core/model/kfoo.dart';
import 'package:app_core/model/kuser.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_response.dart';

part 'video_action_response.g.dart';

@JsonSerializable()
class VideoActionResponse extends BaseResponse {
  @JsonKey(name: "foos")
  List<KFoo>? foos;

  // JSON
  VideoActionResponse();

  factory VideoActionResponse.fromJson(Map<String, dynamic> json) =>
      _$VideoActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VideoActionResponseToJson(this);
}
