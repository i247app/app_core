import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

import 'kobject.dart';

part 'live_share.g.dart';

@JsonSerializable()
class LiveShare extends KObject {
  @JsonKey(name: "ssID")
  String? ssID;

  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "refApp")
  String? refApp;

  @JsonKey(name: "refID")
  String? refID;

  @JsonKey(name: "role")
  String? role;

  // @JsonKey(name: "action")
  // String? action;

  @JsonKey(name: "refPUID")
  String? refPUID;

  @JsonKey(name: "chapterID")
  String? chapterID;

  @JsonKey(name: "textbookID")
  String? textbookID;

  @JsonKey(name: "mime")
  String? mime;

  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "index")
  String? index;

  @JsonKey(name: "shareDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? shareDate;

  // JSON
  LiveShare();

  factory LiveShare.fromJson(Map<String, dynamic> json) => _$LiveShareFromJson(json);

  Map<String, dynamic> toJson() => _$LiveShareToJson(this);
}
