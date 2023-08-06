import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

import 'kobject.dart';

part 'share.g.dart';

@JsonSerializable()
class Share extends KObject {
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
  Share();

  factory Share.fromJson(Map<String, dynamic> json) => _$ShareFromJson(json);

  Map<String, dynamic> toJson() => _$ShareToJson(this);
}
