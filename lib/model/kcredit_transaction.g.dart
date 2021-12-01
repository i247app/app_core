// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kcredit_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KCreditTransaction _$KCreditTransactionFromJson(Map<String, dynamic> json) =>
    KCreditTransaction()
      ..assPUID = json['assPUID'] as String?
      ..txID = json['txID'] as String?
      ..lineID = json['lineID'] as String?
      ..lineDate = json['lineDate'] as String?
      ..lineType = json['lineType'] as String?
      ..xfrType = json['xfrType'] as String?
      ..amount = json['amount'] as String?
      ..tokenName = json['tokenName'] as String?
      ..puid = json['puid'] as String?
      ..poiPUID = json['poiPUID'] as String?
      ..poiKUNM = json['poiKUNM'] as String?
      ..poiFirstName = json['poiFirstName'] as String?
      ..poiMiddleName = json['poiMiddleName'] as String?
      ..poiLastName = json['poiLastName'] as String?
      ..poiFone = json['poiFone'] as String?
      ..poiBusinessName = json['poiBusinessName'] as String?;

Map<String, dynamic> _$KCreditTransactionToJson(KCreditTransaction instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('assPUID', instance.assPUID);
  writeNotNull('txID', instance.txID);
  writeNotNull('lineID', instance.lineID);
  writeNotNull('lineDate', instance.lineDate);
  writeNotNull('lineType', instance.lineType);
  writeNotNull('xfrType', instance.xfrType);
  writeNotNull('amount', instance.amount);
  writeNotNull('tokenName', instance.tokenName);
  writeNotNull('puid', instance.puid);
  writeNotNull('poiPUID', instance.poiPUID);
  writeNotNull('poiKUNM', instance.poiKUNM);
  writeNotNull('poiFirstName', instance.poiFirstName);
  writeNotNull('poiMiddleName', instance.poiMiddleName);
  writeNotNull('poiLastName', instance.poiLastName);
  writeNotNull('poiFone', instance.poiFone);
  writeNotNull('poiBusinessName', instance.poiBusinessName);
  return val;
}
