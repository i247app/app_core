import 'package:json_annotation/json_annotation.dart';

part 'share.g.dart';

@JsonSerializable()
class Share {
  @JsonKey(name: "chapterID")
  String? chapterID;

  @JsonKey(name: "textbookID")
  String? textbookID;

  @JsonKey(name: "role")
  String? role;

  @JsonKey(name: "refPUID")
  String? refPUID;

  @JsonKey(name: "refApp")
  String? refApp;

  @JsonKey(name: "refID")
  String? refID;

  @JsonKey(name: "action")
  String? action;

  @JsonKey(name: "req")
  String? req;

  @JsonKey(name: "svc")
  String? svc;

  // JSON
  Share();

  factory Share.fromJson(Map<String, dynamic> json) => _$ShareFromJson(json);

  Map<String, dynamic> toJson() => _$ShareToJson(this);
}
