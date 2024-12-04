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

Map<String, dynamic> _$GetBanksResponseToJson(GetBanksResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.banks?.map((e) => e.toJson()).toList() case final value?)
        'banks': value,
    };
