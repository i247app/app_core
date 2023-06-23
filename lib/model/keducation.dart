import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/kobject.dart';

part 'keducation.g.dart';

@JsonSerializable()
class KEducation extends KObject {
  static const String ACTION_LIST = "list";
  static const String ACTION_ADD = "add";
  static const String ACTION_MODIFY = "modify";
  static const String ACTION_REMOVE = "remove";

  @JsonKey(name: "educationID")
  String? id;

  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "schoolName")
  String? schoolName;

  @JsonKey(name: "degree")
  String? degree;

  @JsonKey(name: "year")
  String? year;

  /// Methods
  @override
  int get hashCode =>
      Object.hash(this.puid, this.schoolName, this.degree, this.year);

  @override
  bool operator ==(other) => this.hashCode == other.hashCode;

  // JSON
  KEducation();

  factory KEducation.fromJson(Map<String, dynamic> json) =>
      _$KEducationFromJson(json);

  Map<String, dynamic> toJson() => _$KEducationToJson(this);
}
