import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/response/base_response.dart';

part 'knote.g.dart';

@JsonSerializable()
class KNote {
  static const String CONTENT_TYPE_TEXT = "text";
  static const String CONTENT_TYPE_IMAGE = "image";

  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "noteDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? noteDate;

  @JsonKey(name: "messageType")
  String? messageType;

  @JsonKey(name: "body")
  String? body;

  @JsonKey(name: "imgData")
  String? imageData;

  @JsonKey(name: "refApp")
  String? refApp;

  @JsonKey(name: "refID")
  String? refID;

  // JSON
  KNote();

  factory KNote.fromJson(Map<String, dynamic> json) => _$KNoteFromJson(json);

  Map<String, dynamic> toJson() => _$KNoteToJson(this);
}
