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
      ..poiBusinessName = json['poiBusinessName'] as String?
      ..memo = json['memo'] as String?;

Map<String, dynamic> _$KCreditTransactionToJson(KCreditTransaction instance) =>
    <String, dynamic>{
      if (instance.assPUID case final value?) 'assPUID': value,
      if (instance.txID case final value?) 'txID': value,
      if (instance.lineID case final value?) 'lineID': value,
      if (instance.lineDate case final value?) 'lineDate': value,
      if (instance.lineType case final value?) 'lineType': value,
      if (instance.xfrType case final value?) 'xfrType': value,
      if (instance.amount case final value?) 'amount': value,
      if (instance.tokenName case final value?) 'tokenName': value,
      if (instance.puid case final value?) 'puid': value,
      if (instance.poiPUID case final value?) 'poiPUID': value,
      if (instance.poiKUNM case final value?) 'poiKUNM': value,
      if (instance.poiFirstName case final value?) 'poiFirstName': value,
      if (instance.poiMiddleName case final value?) 'poiMiddleName': value,
      if (instance.poiLastName case final value?) 'poiLastName': value,
      if (instance.poiFone case final value?) 'poiFone': value,
      if (instance.poiBusinessName case final value?) 'poiBusinessName': value,
      if (instance.memo case final value?) 'memo': value,
    };
