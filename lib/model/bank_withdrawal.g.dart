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

Map<String, dynamic> _$BankWithdrawalToJson(BankWithdrawal instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.puid case final value?) 'puid': value,
      if (zzz_date2Str(instance.withdrawalDate) case final value?)
        'withdrawalDate': value,
      if (instance.kunm case final value?) 'kunm': value,
      if (instance.name case final value?) 'name': value,
      if (instance.bankID case final value?) 'bankID': value,
      if (instance.bankName case final value?) 'bankName': value,
      if (instance.bankAccountName case final value?) 'bankAccountName': value,
      if (instance.bankAccountNumber case final value?)
        'bankAccountNumber': value,
      if (instance.amount case final value?) 'amount': value,
      if (instance.tokenName case final value?) 'tokenName': value,
      if (instance.txID case final value?) 'txID': value,
      if (instance.withdrawalStatus case final value?)
        'withdrawalStatus': value,
    };
