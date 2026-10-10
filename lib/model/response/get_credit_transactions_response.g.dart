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
    GetCreditTransactionsResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('creditTransactions',
      instance.transactions?.map((e) => e.toJson()).toList());
  return val;
}
