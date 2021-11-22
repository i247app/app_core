import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resume_session_response.g.dart';

@JsonSerializable()
class ResumeSessionResponse extends BaseResponse implements KSessionInitData {
  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "userSession")
  KUserSession? userSession;

  // Getters
  @override
  @JsonKey(ignore: true)
  String get initSessionToken => this.ktoken!;

  @override
  @JsonKey(ignore: true)
  KUserSession get initUserSession => this.userSession!;

  // JSON
  ResumeSessionResponse();

  factory ResumeSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$ResumeSessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResumeSessionResponseToJson(this);
}
