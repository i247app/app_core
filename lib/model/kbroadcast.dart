import 'package:app_core/model/kobject.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kbroadcast.g.dart';

@JsonSerializable()
class KBroadcast extends KObject {
  @JsonKey(name: "broadcast")
  String? broadcast;

  @JsonKey(name: "broadcastID")
  String? broadcastID;

  @JsonKey(name: "byPuid")
  String? byPUID;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "promoCode")
  String? promoCode;

  @JsonKey(name: "reserveDate")
  String? reserveDate;

  @JsonKey(name: "broadcastDate")
  String? broadcastDate;

  @JsonKey(name: "count")
  String? count;

  @JsonKey(name: "isPaid", fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isPaid;

  @JsonKey(name: "toAll", fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? toAll;

  @JsonKey(name: "broadcastStatus")
  String? broadcastStatus;

  @JsonKey(name: "recipients")
  List<String>? recipients;

  // JSON
  KBroadcast();

  factory KBroadcast.fromJson(Map<String, dynamic> json) => _$KBroadcastFromJson(json);

  Map<String, dynamic> toJson() => _$KBroadcastToJson(this);
}
