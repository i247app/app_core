import 'package:json_annotation/json_annotation.dart';

part 'kflash.g.dart';

@JsonSerializable()
class KFlash {
  static const String TYPE_RAIN = "rain";
  static const String TYPE_BANNER = "banner";

  static const String MEDIA_EMOJI = "emoji";
  static const String MEDIA_IMAGE = "image";
  static const String MEDIA_TEXT = "text";
  static const String MEDIA_CONFETTI = "confetti";
  static const String MEDIA_HERO = "hero";

  // VALUE Emoji
  static const String VALUE_SMILEY = "smiley";
  static const String VALUE_FROWN = "frown";
  static const String VALUE_STAR = "star";
  static const String VALUE_BITCOIN = "bitcoin";
  static const String VALUE_THUMB_UP = "thumbUp";
  static const String VALUE_THUMB_DOWN = "thumbDown";
  static const String VALUE_PHO = "pho";

  // VALUE Confetti
  static const String VALUE_PAPER = "paper";

  // VALUE Hero
  static const String VALUE_DURIMAN = "duriman";
  static const String VALUE_FUGU = "fugu";

  @JsonKey(name: "flashType")
  String? flashType;

  @JsonKey(name: "mediaType")
  String? mediaType;

  @JsonKey(name: "media")
  String? media;

  @JsonKey(name: "nickName")
  String? nickName;

  // JSON
  KFlash();

  factory KFlash.fromJson(Map<String, dynamic> json) => _$KFlashFromJson(json);

  Map<String, dynamic> toJson() => _$KFlashToJson(this);
}
