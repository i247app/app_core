import 'package:app_core/model/ktag.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_tag.g.dart';

@JsonSerializable()
class UserTag extends KTag {
  @JsonKey(name: "puid")
  String? puid;

  // JSON
  UserTag();

  factory UserTag.fromJson(Map<String, dynamic> json) =>
      _$UserTagFromJson(json);

  Map<String, dynamic> toJson() => _$UserTagToJson(this);
}
