// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_business_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBusinessResponse _$GetBusinessResponseFromJson(Map<String, dynamic> json) =>
    GetBusinessResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..business = json['business'] == null
          ? null
          : Business.fromJson(json['business'] as Map<String, dynamic>);

Map<String, dynamic> _$GetBusinessResponseToJson(
        GetBusinessResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.business?.toJson() case final value?) 'business': value,
    };
