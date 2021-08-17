import 'package:json_annotation/json_annotation.dart';

part 'kflash.g.dart';

@JsonSerializable()
class KFlash {
  static const String SMILEY = "smiley";
  static const String PHO = "pho";

  static const String TYPE_RAIN = "rain";
  static const String TYPE_BANNER = "banner";

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
