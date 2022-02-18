import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'kgame_score.g.dart';

@JsonSerializable()
class KGameScore {
  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "kunm")
  String? kunm;

  @JsonKey(name: "avatar")
  String? avatarURL;

  @JsonKey(name: "gameID")
  String? game;

  @JsonKey(name: "level")
  String? level;

  @JsonKey(name: "ranking")
  String? ranking;

  @JsonKey(name: "rankDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? rankDate;

  @JsonKey(name: "score")
  String? score;

  @JsonKey(name: "scoreType")
  String? scoreType;

  @JsonKey(name: "time")
  String? time;

  @JsonKey(name: "point")
  String? point;

  @JsonKey(name: "scoreDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? scoreDate;

  @JsonKey(name: "gameAppID")
  String? gameAppID;

  @JsonKey(name: "language")
  String? language;

  @JsonKey(name: "topic")
  String? topic;

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
