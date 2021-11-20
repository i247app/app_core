import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'keducation.g.dart';

@JsonSerializable()
class KEducation {
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
      hashValues(this.puid, this.schoolName, this.degree, this.year);

  @override
  bool operator ==(other) => this.hashCode == other.hashCode;

  // JSON
  KEducation();

  factory KEducation.fromJson(Map<String, dynamic> json) =>
      _$KEducationFromJson(json);

  Map<String, dynamic> toJson() => _$KEducationToJson(this);
}
