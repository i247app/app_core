// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kbalance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KBalance _$KBalanceFromJson(Map<String, dynamic> json) => KBalance()
  ..puid = json['puid'] as String?
  ..tokenName = json['tokenName'] as String?
  ..amount = json['amount'] as String?;

Map<String, dynamic> _$KBalanceToJson(KBalance instance) => <String, dynamic>{
      if (instance.puid case final value?) 'puid': value,
      if (instance.tokenName case final value?) 'tokenName': value,
      if (instance.amount case final value?) 'amount': value,
    };
