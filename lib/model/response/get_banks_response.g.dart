// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_banks_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBanksResponse _$GetBanksResponseFromJson(Map<String, dynamic> json) =>
    GetBanksResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..banks = (json['banks'] as List<dynamic>?)
          ?.map((e) => KBank.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GetBanksResponseToJson(GetBanksResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('banks', instance.banks?.map((e) => e.toJson()).toList());
  return val;
}
