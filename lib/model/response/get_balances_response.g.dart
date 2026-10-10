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

Map<String, dynamic> _$GetBalancesResponseToJson(GetBalancesResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('balances', instance.balances?.map((e) => e.toJson()).toList());
  return val;
}
