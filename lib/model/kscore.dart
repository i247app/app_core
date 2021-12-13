import 'package:app_core/model/kuser.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'kscore.g.dart';

@JsonSerializable()
class KScore {
  @JsonKey(name: "scoreID")
  String? scoreID;

  @JsonKey(name: "user")
  KUser? user;

  @JsonKey(name: "game")
  String? game;

  @JsonKey(name: "level")
  int? level;

  @JsonKey(name: "score")
  double? score;

  // JSON
  KScore();

  factory KScore.fromJson(Map<String, dynamic> json) => _$KScoreFromJson(json);

  Map<String, dynamic> toJson() => _$KScoreToJson(this);

  static String encode(List<KScore> scores) => json.encode(
        scores.map<Map<String, dynamic>>((score) => score.toJson()).toList(),
      );

  static List<KScore> decode(String scores) =>
      (json.decode(scores) as List<dynamic>)
          .map<KScore>((item) => KScore.fromJson(item))
          .toList();
}
