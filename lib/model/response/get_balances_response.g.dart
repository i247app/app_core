// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_balances_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBalancesResponse _$GetBalancesResponseFromJson(Map<String, dynamic> json) =>
    GetBalancesResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..balances = (json['balances'] as List<dynamic>?)
          ?.map((e) => KBalance.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GetBalancesResponseToJson(
        GetBalancesResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.balances?.map((e) => e.toJson()).toList() case final value?)
        'balances': value,
    };
