import 'package:app_core/app_core.dart';
import 'package:app_core/model/kcredit_transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credit_transfer_response.g.dart';

@JsonSerializable()
class CreditTransferResponse extends BaseResponse {
  @JsonKey(name: "amount")
  String? amount;

  @JsonKey(name: "refKUID")
  String? refPUID;

  @JsonKey(name: "txID")
  String? transactionID;

  @JsonKey(name: "transaction")
  KCreditTransaction? transaction;

  // JSON
  CreditTransferResponse();

  factory CreditTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$CreditTransferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreditTransferResponseToJson(this);
}
