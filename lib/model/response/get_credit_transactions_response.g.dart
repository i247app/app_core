// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_credit_transactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCreditTransactionsResponse _$GetCreditTransactionsResponseFromJson(
        Map<String, dynamic> json) =>
    GetCreditTransactionsResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..transactions = (json['creditTransactions'] as List<dynamic>?)
          ?.map((e) => KCreditTransaction.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GetCreditTransactionsResponseToJson(
        GetCreditTransactionsResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.transactions?.map((e) => e.toJson()).toList()
          case final value?)
        'creditTransactions': value,
    };
