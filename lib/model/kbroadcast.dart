import 'package:app_core/model/kobject.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'kaddress.dart';
import 'klat_lng.dart';

part 'kbroadcast.g.dart';

@JsonSerializable()
class KBroadcast extends KObject {
  @JsonKey(name: "broadcastID")
  String? broadcastID;

  @JsonKey(name: "byPUID")
  String? byPUID;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "promoCode")
  String? promoCode;

  @JsonKey(name: "reserveDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? reserveDate;

  @JsonKey(name: "broadcastDate")
  String? broadcastDate;

  @JsonKey(name: "broadcastMax")
  String? broadcastMax;

  @JsonKey(name: "broadcastCount")
  String? broadcastCount;

  @JsonKey(name: "isPaid", fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isPaid;

  @JsonKey(name: "toAll", fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? toAll;

  @JsonKey(name: "recipients")
  List<String>? recipients;

  @JsonKey(name: "recipientType")
  String? recipientType;

  @JsonKey(name: "addresses")
  List<KAddress>? addresses;

  @JsonKey(name: "latLng")
  KLatLng? latLng;

  @JsonKey(name: "broadcastStatus")
  String? broadcastStatus;

  // JSON
  KBroadcast();

  factory KBroadcast.fromJson(Map<String, dynamic> json) => _$KBroadcastFromJson(json);

  Map<String, dynamic> toJson() => _$KBroadcastToJson(this);
}
