import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'kgame_score.g.dart';

@JsonSerializable()
class KGameScore {
  @JsonKey(name: "scoreID")
  String? scoreID;

  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "kunm")
  String? kunm;

  @JsonKey(name: "avatarURL")
  String? avatarURL;

  @JsonKey(name: "gameID")
  String? game;

  @JsonKey(name: "level")
  int? level;

  @JsonKey(name: "score")
  double? score;

  @JsonKey(name: "scoreDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? scoreDate;

  // JSON
  KGameScore();

  factory KGameScore.fromJson(Map<String, dynamic> json) =>
      _$KGameScoreFromJson(json);

  Map<String, dynamic> toJson() => _$KGameScoreToJson(this);

  static String encode(List<KGameScore> scores) => json.encode(
        scores.map<Map<String, dynamic>>((score) => score.toJson()).toList(),
      );

  static List<KGameScore> decode(String scores) =>
      (json.decode(scores) as List<dynamic>)
          .map<KGameScore>((item) => KGameScore.fromJson(item))
          .toList();
}
