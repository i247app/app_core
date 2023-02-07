import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kgig_user.g.dart';

@JsonSerializable()
class KGigUser extends KUser {
  // JSON
  KGigUser();

  factory KGigUser.fromJson(Map<String, dynamic> json) => _$KGigUserFromJson(json);

  Map<String, dynamic> toJson() => _$KGigUserToJson(this);
}