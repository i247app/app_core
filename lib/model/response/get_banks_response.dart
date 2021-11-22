import 'package:app_core/app_core.dart';
import 'package:app_core/model/kbank.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_banks_response.g.dart';

@JsonSerializable()
class GetBanksResponse extends BaseResponse {
  @JsonKey(name: "banks")
  List<KBank>? banks;

  // JSON
  GetBanksResponse();

  factory GetBanksResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBanksResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetBanksResponseToJson(this);
}
