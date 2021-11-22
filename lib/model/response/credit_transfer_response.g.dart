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
      ..transaction = json['transaction'] == null
          ? null
          : KCreditTransaction.fromJson(
              json['transaction'] as Map<String, dynamic>);

Map<String, dynamic> _$CreditTransferResponseToJson(
    CreditTransferResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('amount', instance.amount);
  writeNotNull('refKUID', instance.refPUID);
  writeNotNull('txID', instance.transactionID);
  writeNotNull('transaction', instance.transaction?.toJson());
  return val;
}
