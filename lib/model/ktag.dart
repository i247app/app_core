import 'package:json_annotation/json_annotation.dart';

part 'ktag.g.dart';

@JsonSerializable()
class KTag {
  @JsonKey(name: "tagID")
  String? tagID;

  @JsonKey(name: "groupIndex")
  String? groupIndex;

  @JsonKey(name: "groupName")
  String? groupName;

  @JsonKey(name: "groupIcon")
  String? groupIcon;

  @JsonKey(name: "tagIndex")
  String? tagIndex;

  @JsonKey(name: "tagName")
  String? tagName;

  @JsonKey(name: "tagIcon")
  String? tagIcon;

  @JsonKey(name: "tagStatus")
  String? tagStatus;

  /// Methods
  @override
  int get hashCode => this.tagID.hashCode;

  @override
  bool operator ==(other) => other is KTag ? this.tagID == other.tagID : false;

  // JSON
  KTag();

  factory KTag.fromJson(Map<String, dynamic> json) => _$KTagFromJson(json);

  Map<String, dynamic> toJson() => _$KTagToJson(this);
}
