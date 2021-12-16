import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bank_withdrawal.g.dart';

@JsonSerializable()
class BankWithdrawal {
  static const String ID = "id";
  static const String PUID = "puid";
  static const String WITHDRAWAL_DATE = "withdrawalDate";
  static const String KUNM = "kunm";
  static const String NAME = "name";
  static const String BANK_ID = "bankID";
  static const String BANK_NAME = "bankName";
  static const String BANK_ACCOUNT_NAME = "bankAccountName";
  static const String BANK_ACCOUNT_NUMBER = "bankAccountNumber";
  static const String AMOUNT = "amount";
  static const String TOKEN_NAME = "tokenName";

  static const String TX_ID = "txID";

  static const String WITHDRAWAL_STATUS = "withdrawalStatus";

  @JsonKey(name: ID)
  String? id;

  @JsonKey(name: PUID)
  String? puid;

  @JsonKey(name: WITHDRAWAL_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? withdrawalDate;

  @JsonKey(name: KUNM)
  String? kunm;

  @JsonKey(name: NAME)
  String? name;

  @JsonKey(name: BANK_ID)
  String? bankID;

  @JsonKey(name: BANK_NAME)
  String? bankName;

  @JsonKey(name: BANK_ACCOUNT_NAME)
  String? bankAccountName;

  @JsonKey(name: BANK_ACCOUNT_NUMBER)
  String? bankAccountNumber;

  @JsonKey(name: AMOUNT)
  String? amount;

  @JsonKey(name: TOKEN_NAME)
  String? tokenName;

  @JsonKey(name: TX_ID)
  String? txID;

  @JsonKey(name: WITHDRAWAL_STATUS)
  String? withdrawalStatus;

  BankWithdrawal();

  factory BankWithdrawal.fromJson(Map<String, dynamic> json) =>
      _$BankWithdrawalFromJson(json);

  Map<String, dynamic> toJson() => _$BankWithdrawalToJson(this);
}
