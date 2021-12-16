import 'package:json_annotation/json_annotation.dart';

import '../kchat.dart';
import '../kgame.dart';
import 'base_response.dart';

part 'get_games_response.g.dart';

@JsonSerializable()
class KGetGamesResponse extends BaseResponse {
  @JsonKey(name: "games")
  List<KGame>? games;

  // JSON
  KGetGamesResponse();

  factory KGetGamesResponse.fromJson(Map<String, dynamic> json) =>
      _$KGetGamesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KGetGamesResponseToJson(this);
}
