import 'package:json_annotation/json_annotation.dart';

part 'kstore_hour.g.dart';

@JsonSerializable()
class KStoreHour {
  static const String BUID = "buid";
  static const String STORE_ID = "storeID";
  static const String OPEN = "openTime";
  static const String CLOSE = "closeTime";
  static const String DAY = "day";

  @JsonKey(name: BUID)
  String? buid;

  @JsonKey(name: STORE_ID)
  String? storeID;

  @JsonKey(name: OPEN)
  String? open;

  @JsonKey(name: CLOSE)
  String? close;

  @JsonKey(name: DAY)
  String? dayIndex;

  // JSON
  KStoreHour();

  factory KStoreHour.fromJson(Map<String, dynamic> json) =>
      _$KStoreHourFromJson(json);

  Map<String, dynamic> toJson() => _$KStoreHourToJson(this);
}
