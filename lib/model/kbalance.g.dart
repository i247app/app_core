// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kbalance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KBalance _$KBalanceFromJson(Map<String, dynamic> json) => KBalance()
  ..puid = json['puid'] as String?
  ..tokenName = json['tokenName'] as String?
  ..amount = json['amount'] as String?;

Map<String, dynamic> _$KBalanceToJson(KBalance instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('puid', instance.puid);
  writeNotNull('tokenName', instance.tokenName);
  writeNotNull('amount', instance.amount);
  return val;
}
