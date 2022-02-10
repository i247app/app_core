import 'package:app_core/model/kqna.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kgame.g.dart';

@JsonSerializable()
class KGame {
  static const String GAME_ID = "gameID";
  static const String GAME_CODE = "gameCode";
  static const String TITLE = "title"; // MULT | WRITTEN
  static const String SUBTITLE = "subtitle";
  static const String TEXT = "text"; // kquestion image or video
  static const String CAT = "cat"; // image | video
  static const String LEVEL = "level";
  static const String MIMETYPE = "mimeType";
  static const String QNAS = "qnas";
  static const String TOPIC = "topic";
  static const String LANGUAGE = "language";
  static const String GAME_APP_ID = "gameAppID";

  @JsonKey(name: GAME_ID)
  String? gameID;

  @JsonKey(name: GAME_APP_ID)
  String? gameAppID;

  @JsonKey(name: GAME_CODE)
  String? gameCode;

  @JsonKey(name: TITLE)
  String? title;

  @JsonKey(name: SUBTITLE)
  String? subtitle;

  @JsonKey(name: TEXT)
  String? text;

  @JsonKey(name: CAT)
  String? cat;

  @JsonKey(name: TOPIC)
  String? topic;

  @JsonKey(name: LANGUAGE)
  String? language;

  @JsonKey(name: LEVEL)
  String? level; // image | video

  @JsonKey(name: MIMETYPE)
  String? mimeType; // image | video

  @JsonKey(name: QNAS)
  List<KQNA>? qnas;

  // JSON
  KGame();

  factory KGame.fromJson(Map<String, dynamic> json) => _$KGameFromJson(json);

  Map<String, dynamic> toJson() => _$KGameToJson(this);
}
