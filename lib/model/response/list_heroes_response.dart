import 'package:json_annotation/json_annotation.dart';

import '../khero.dart';
import 'base_response.dart';

part 'list_heroes_response.g.dart';

@JsonSerializable()
class KListHeroesResponse extends BaseResponse {
  @JsonKey(name: "heroes")
  List<KHero>? heroes;

  // JSON
  KListHeroesResponse();

  factory KListHeroesResponse.fromJson(Map<String, dynamic> json) =>
      _$KListHeroesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KListHeroesResponseToJson(this);
}
