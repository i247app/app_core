// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_transfer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditTransferResponse _$CreditTransferResponseFromJson(
        Map<String, dynamic> json) =>
    CreditTransferResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..amount = json['amount'] as String?
      ..refPUID = json['refKUID'] as String?
      ..transactionID = json['txID'] as String?
      ..transactions = (json['transactions'] as List<dynamic>?)
          ?.map((e) => KCreditTransaction.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CreditTransferResponseToJson(
        CreditTransferResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.amount case final value?) 'amount': value,
      if (instance.refPUID case final value?) 'refKUID': value,
      if (instance.transactionID case final value?) 'txID': value,
      if (instance.transactions?.map((e) => e.toJson()).toList()
          case final value?)
        'transactions': value,
    };
