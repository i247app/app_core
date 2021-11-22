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
  ..cardLength = json['cardLength'] as int?
  ..shortName = json['shortName'] as String?
  ..bankCode = json['bankCode'] as String?
  ..type = json['type'] as String?
  ..napasSupported = json['napasSupported'] as bool?;

Map<String, dynamic> _$KBankToJson(KBank instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('en_name', instance.enName);
  writeNotNull('vn_name', instance.viName);
  writeNotNull('bankId', instance.bankId);
  writeNotNull('atmBin', instance.atmBin);
  writeNotNull('cardLength', instance.cardLength);
  writeNotNull('shortName', instance.shortName);
  writeNotNull('bankCode', instance.bankCode);
  writeNotNull('type', instance.type);
  writeNotNull('napasSupported', instance.napasSupported);
  return val;
}
