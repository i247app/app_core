import 'package:app_core/app_core.dart';
import 'package:app_core/model/kbalance.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_balances_response.g.dart';

@JsonSerializable()
class GetBalancesResponse extends BaseResponse {
  @JsonKey(name: "balances")
  List<KBalance>? balances;

  // JSON
  GetBalancesResponse();

  factory GetBalancesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBalancesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetBalancesResponseToJson(this);
}
