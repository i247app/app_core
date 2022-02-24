import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'share.g.dart';

@JsonSerializable()
class Share {
  @JsonKey(name: "shareID")
  String? shareID;

  @JsonKey(name: "refPUID")
  String? refPUID;

  @JsonKey(name: "refApp")
  String? refApp;

  @JsonKey(name: "refID")
  String? refID;

  @JsonKey(name: "chapterID")
  String? chapterID;

  @JsonKey(name: "textbookID")
  String? textbookID;

  @JsonKey(name: "mime")
  String? mime;

  @JsonKey(name: "role")
  String? role;

  @JsonKey(name: "action")
  String? action;

  @JsonKey(name: "shareDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? shareDate;

  // JSON
  Share();

  factory Share.fromJson(Map<String, dynamic> json) => _$ShareFromJson(json);

  Map<String, dynamic> toJson() => _$ShareToJson(this);
}
