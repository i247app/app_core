import 'package:app_core/model/kgame_score.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'save_score_response.g.dart';

@JsonSerializable()
class KSaveScoreResponse extends BaseResponse {
  @JsonKey(name: "gameScores")
  List<KGameScore>? gameScores;

  // JSON
  KSaveScoreResponse();

  factory KSaveScoreResponse.fromJson(Map<String, dynamic> json) =>
      _$KSaveScoreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KSaveScoreResponseToJson(this);
}
