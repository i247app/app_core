import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/kuser.dart';

part 'kflash.g.dart';

@JsonSerializable()
class KFlash {
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
