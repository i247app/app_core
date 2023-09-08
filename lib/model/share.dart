import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

import 'kobject.dart';

part 'share.g.dart';

@JsonSerializable()
class Share extends KObject {
  static const String APP_ID_CARD = "ID_CARD";

  @JsonKey(name: "shareID")
  String? shareID;

  @JsonKey(name: "byPUID")
  String? byPUID;

  @JsonKey(name: "toPUID")
  String? toPUID;

  @JsonKey(name: "refMime")
  String? refMime;

  @JsonKey(name: "refID")
  String? refID;

  @JsonKey(name: "refApp")
  String? refApp;

  @JsonKey(name: "refURL")
  String? refURL;

  @JsonKey(name: "shareStatus")
  String? shareStatus;

  @JsonKey(name: "shareDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? shareDate;

  // JSON
  Share();

  factory Share.fromJson(Map<String, dynamic> json) => _$ShareFromJson(json);

  Map<String, dynamic> toJson() => _$ShareToJson(this);
}
