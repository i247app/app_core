import 'package:app_core/model/klat_lng.dart';
import 'package:app_core/model/kobject.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kcheck_in.g.dart';

@JsonSerializable()
class KCheckIn extends KObject {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "placeID")
  String? placeID;

  @JsonKey(name: "addressLine")
  String? addressLine;

  @JsonKey(name: "latLng")
  KLatLng? latLng;

  @JsonKey(name: "minutePerSession")
  int? minutePerSession;

  @JsonKey(name: "checkInDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? checkInDate;

  @JsonKey(name: "checkInStatus")
  String? checkInStatus;

  // JSON
  KCheckIn();

  factory KCheckIn.fromJson(Map<String, dynamic> json) =>
      _$KCheckInFromJson(json);

  Map<String, dynamic> toJson() => _$KCheckInToJson(this);
}
