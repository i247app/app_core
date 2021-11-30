import 'package:json_annotation/json_annotation.dart';

part 'krole.g.dart';

@JsonSerializable()
class KRole {
  static const String PUID = "puid";
  static const String BUID = "buid";
  static const String ROLE = "role";
  static const String BNM = "bnm";
  static const String AVATAR_URL = "avatar";

  @JsonKey(name: PUID)
  String? puid;

  @JsonKey(name: BUID)
  String? buid;

  @JsonKey(name: ROLE)
  String? role;

  @JsonKey(name: BNM)
  String? bnm;

  @JsonKey(name: AVATAR_URL)
  String? avatarURL;

  // Methods
  @JsonKey(ignore: true)
  bool isMePlaceholder = false;

  // JSON
  KRole();

  factory KRole.fromJson(Map<String, dynamic> json) => _$KRoleFromJson(json);

  Map<String, dynamic> toJson() => _$KRoleToJson(this);
}
