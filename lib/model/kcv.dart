import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'kobject.dart';

part 'kcv.g.dart';

@JsonSerializable()
class KCV extends KObject {
  static const String ACTION_ADD = "add";
  static const String ACTION_LIST = "list";
  static const String ACTION_MODIFY = "modify";
  static const String ACTION_REMOVE = "remove";

  // @JsonKey(name: "cv")
  // String? cv;

  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "cvDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? cvDate;

  @JsonKey(name: "cvText")
  String? cvText;

  @JsonKey(name: "cvStatus")
  String? cvStatus;

  @JsonKey(name: "kunm")
  String? kunm;

  @JsonKey(name: "firstName")
  String? firstName;

  @JsonKey(name: "middleName")
  String? middleName;

  @JsonKey(name: "lastName")
  String? lastName;

  @JsonKey(name: "avatar")
  String? avatar;

  @JsonKey(name: "user")
  String? user;

  // JSON
  KCV();

  factory KCV.fromJson(Map<String, dynamic> json) => _$KCVFromJson(json);

  Map<String, dynamic> toJson() => _$KCVToJson(this);
}
