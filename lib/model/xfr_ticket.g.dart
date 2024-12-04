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
      memo: json['memo'] as String?,
    )
      ..byPUID = json['byPUID'] as String?
      ..rcvKUNM = json['rcvKUNM'] as String?
      ..rcvEmail = json['rcvEmail'] as String?
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

Map<String, dynamic> _$XFRTicketToJson(XFRTicket instance) => <String, dynamic>{
      if (instance.byPUID case final value?) 'byPUID': value,
      if (instance.sndPUID case final value?) 'sndPUID': value,
      if (instance.rcvPUID case final value?) 'rcvPUID': value,
      if (instance.rcvKUNM case final value?) 'rcvKUNM': value,
      if (instance.rcvEmail case final value?) 'rcvEmail': value,
      if (instance.rcvFone case final value?) 'rcvFone': value,
      if (instance.amount case final value?) 'amount': value,
      if (instance.tokenName case final value?) 'tokenName': value,
      if (instance.memo case final value?) 'memo': value,
      if (instance.xfrID case final value?) 'xfrID': value,
      if (instance.xfrType case final value?) 'xfrType': value,
      if (instance.xfrDate case final value?) 'xfrDate': value,
      if (instance.message case final value?) 'message': value,
      if (instance.promoCode case final value?) 'promoCode': value,
      if (instance.feeRate case final value?) 'feeRate': value,
      if (instance.feeAmount case final value?) 'feeAmount': value,
      if (instance.byKUID case final value?) 'byKUID': value,
      if (instance.sndKAID case final value?) 'sndKAID': value,
      if (instance.rcvKUID case final value?) 'rcvKUID': value,
      if (instance.rcvKAID case final value?) 'rcvKAID': value,
      if (zzz_bool2Str(instance.isAutoCreate) case final value?)
        'isAutoCreate': value,
      if (instance.promotionType case final value?) 'promotionType': value,
    };
