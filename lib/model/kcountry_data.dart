import 'package:json_annotation/json_annotation.dart';

part 'kcountry_data.g.dart';

@JsonSerializable()
class KCountryData {
  @JsonKey(name: "code")
  late String code;

  @JsonKey(name: "label")
  late String label;

  @JsonKey(name: "phoneCode")
  late String phoneCode;

  /// Methods
  KCountryData.raw({
    required this.code,
    required this.label,
    required this.phoneCode,
  });

  // JSON
  KCountryData();

  factory KCountryData.fromJson(Map<String, dynamic> json) =>
      _$KCountryDataFromJson(json);

  Map<String, dynamic> toJson() => _$KCountryDataToJson(this);
}
