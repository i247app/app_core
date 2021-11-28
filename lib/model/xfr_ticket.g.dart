// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xfr_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XFRTicket _$XFRTicketFromJson(Map<String, dynamic> json) => XFRTicket(
      promotionType: json['promotionType'] as String?,
      promoCode: json['promoCode'] as String?,
      sndPUID: json['sndPUID'] as String?,
      rcvFone: json['rcvFone'] as String?,
      rcvPUID: json['rcvPUID'] as String?,
      tokenName: json['tokenName'] as String?,
      amount: json['amount'] as String?,
    )
      ..byPUID = json['byPUID'] as String?
      ..rcvKUNM = json['rcvKUNM'] as String?
      ..rcvEmail = json['rcvEmail'] as String?
      ..memo = json['memo'] as String?
      ..xfrID = json['xfrID'] as String?
      ..xfrType = json['xfrType'] as String?
      ..xfrDate = json['xfrDate'] as String?
      ..message = json['message'] as String?
      ..feeRate = json['feeRate'] as String?
      ..feeAmount = json['feeAmount'] as String?
      ..byKUID = json['byKUID'] as String?
      ..sndKAID = json['sndKAID'] as String?
      ..rcvKUID = json['rcvKUID'] as String?
      ..rcvKAID = json['rcvKAID'] as String?
      ..isAutoCreate = zzz_str2Bool(json['isAutoCreate'] as String?);

Map<String, dynamic> _$XFRTicketToJson(XFRTicket instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('byPUID', instance.byPUID);
  writeNotNull('sndPUID', instance.sndPUID);
  writeNotNull('rcvPUID', instance.rcvPUID);
  writeNotNull('rcvKUNM', instance.rcvKUNM);
  writeNotNull('rcvEmail', instance.rcvEmail);
  writeNotNull('rcvFone', instance.rcvFone);
  writeNotNull('amount', instance.amount);
  writeNotNull('tokenName', instance.tokenName);
  writeNotNull('memo', instance.memo);
  writeNotNull('xfrID', instance.xfrID);
  writeNotNull('xfrType', instance.xfrType);
  writeNotNull('xfrDate', instance.xfrDate);
  writeNotNull('message', instance.message);
  writeNotNull('promoCode', instance.promoCode);
  writeNotNull('feeRate', instance.feeRate);
  writeNotNull('feeAmount', instance.feeAmount);
  writeNotNull('byKUID', instance.byKUID);
  writeNotNull('sndKAID', instance.sndKAID);
  writeNotNull('rcvKUID', instance.rcvKUID);
  writeNotNull('rcvKAID', instance.rcvKAID);
  writeNotNull('isAutoCreate', zzz_bool2Str(instance.isAutoCreate));
  writeNotNull('promotionType', instance.promotionType);
  return val;
}
