// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_withdrawal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankWithdrawal _$BankWithdrawalFromJson(Map<String, dynamic> json) =>
    BankWithdrawal()
      ..id = json['id'] as String?
      ..puid = json['puid'] as String?
      ..withdrawalDate = zzz_str2Date(json['withdrawalDate'] as String?)
      ..kunm = json['kunm'] as String?
      ..name = json['name'] as String?
      ..bankID = json['bankID'] as String?
      ..bankName = json['bankName'] as String?
      ..bankAccountName = json['bankAccountName'] as String?
      ..bankAccountNumber = json['bankAccountNumber'] as String?
      ..amount = json['amount'] as String?
      ..tokenName = json['tokenName'] as String?
      ..txID = json['txID'] as String?
      ..withdrawalStatus = json['withdrawalStatus'] as String?;

Map<String, dynamic> _$BankWithdrawalToJson(BankWithdrawal instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('puid', instance.puid);
  writeNotNull('withdrawalDate', zzz_date2Str(instance.withdrawalDate));
  writeNotNull('kunm', instance.kunm);
  writeNotNull('name', instance.name);
  writeNotNull('bankID', instance.bankID);
  writeNotNull('bankName', instance.bankName);
  writeNotNull('bankAccountName', instance.bankAccountName);
  writeNotNull('bankAccountNumber', instance.bankAccountNumber);
  writeNotNull('amount', instance.amount);
  writeNotNull('tokenName', instance.tokenName);
  writeNotNull('txID', instance.txID);
  writeNotNull('withdrawalStatus', instance.withdrawalStatus);
  return val;
}
