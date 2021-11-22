import 'package:json_annotation/json_annotation.dart';

part 'kbank.g.dart';

@JsonSerializable()
class KBank {
  @JsonKey(name: "en_name")
  String? enName;

  @JsonKey(name: "vn_name")
  String? viName;

  @JsonKey(name: "bankId")
  String? bankId;

  @JsonKey(name: "atmBin")
  String? atmBin;

  @JsonKey(name: "cardLength")
  int? cardLength;

  @JsonKey(name: "shortName")
  String? shortName;

  @JsonKey(name: "bankCode")
  String? bankCode;

  @JsonKey(name: "type")
  String? type;

  @JsonKey(name: "napasSupported")
  bool? napasSupported;

  // JSON
  KBank();

  factory KBank.fromJson(Map<String, dynamic> json) => _$KBankFromJson(json);

  Map<String, dynamic> toJson() => _$KBankToJson(this);
}
