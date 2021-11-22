import 'package:app_core/app_core.dart';
import 'package:app_core/model/kcredit_transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_credit_transactions_response.g.dart';

@JsonSerializable()
class GetCreditTransactionsResponse extends BaseResponse {
  @JsonKey(
      name:
          "creditTransactions") // TODO maybe rename to transactions or creditTransactions
  List<KCreditTransaction>? transactions; // why not name it creditTransactions

  // JSON
  GetCreditTransactionsResponse();

  factory GetCreditTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCreditTransactionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetCreditTransactionsResponseToJson(this);
}
