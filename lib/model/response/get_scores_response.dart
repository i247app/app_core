import 'package:json_annotation/json_annotation.dart';

import '../kgame_score.dart';
import 'base_response.dart';

part 'get_scores_response.g.dart';

@JsonSerializable()
class KGetGameScoresResponse extends BaseResponse {
  @JsonKey(name: "gameScores")
  List<KGameScore>? scores;

  // JSON
  KGetGameScoresResponse();

  factory KGetGameScoresResponse.fromJson(Map<String, dynamic> json) =>
      _$KGetGameScoresResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KGetGameScoresResponseToJson(this);
}
