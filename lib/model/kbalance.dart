import 'package:json_annotation/json_annotation.dart';

part 'kbalance.g.dart';

@JsonSerializable()
class KBalance {
  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "tokenName")
  String? tokenName;

  @JsonKey(name: "amount")
  String? amount;

  // JSON
  KBalance();

  factory KBalance.fromJson(Map<String, dynamic> json) =>
      _$KBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$KBalanceToJson(this);
}
