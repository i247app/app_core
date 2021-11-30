import 'package:app_core/app_core.dart';
import 'package:app_core/model/krole.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_xfr_role_response.g.dart';

@JsonSerializable()
class ListXFRRoleResponse extends BaseResponse {
  @JsonKey(name: "xfrRoles")
  List<KRole>? roles;

  // JSON
  ListXFRRoleResponse();

  factory ListXFRRoleResponse.fromJson(Map<String, dynamic> json) =>
      _$ListXFRRoleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListXFRRoleResponseToJson(this);
}
