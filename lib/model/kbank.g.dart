// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kbank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KBank _$KBankFromJson(Map<String, dynamic> json) => KBank()
  ..enName = json['en_name'] as String?
  ..viName = json['vn_name'] as String?
  ..bankId = json['bankId'] as String?
  ..atmBin = json['atmBin'] as String?
  ..cardLength = (json['cardLength'] as num?)?.toInt()
  ..shortName = json['shortName'] as String?
  ..bankCode = json['bankCode'] as String?
  ..type = json['type'] as String?
  ..napasSupported = json['napasSupported'] as bool?;

Map<String, dynamic> _$KBankToJson(KBank instance) => <String, dynamic>{
      if (instance.enName case final value?) 'en_name': value,
      if (instance.viName case final value?) 'vn_name': value,
      if (instance.bankId case final value?) 'bankId': value,
      if (instance.atmBin case final value?) 'atmBin': value,
      if (instance.cardLength case final value?) 'cardLength': value,
      if (instance.shortName case final value?) 'shortName': value,
      if (instance.bankCode case final value?) 'bankCode': value,
      if (instance.type case final value?) 'type': value,
      if (instance.napasSupported case final value?) 'napasSupported': value,
    };
