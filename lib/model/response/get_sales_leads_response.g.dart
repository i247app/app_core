// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_sales_leads_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGetSalesLeadsResponse _$KGetSalesLeadsResponseFromJson(
        Map<String, dynamic> json) =>
    KGetSalesLeadsResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..leads = (json['leads'] as List<dynamic>?)
          ?.map((e) => KLead.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KGetSalesLeadsResponseToJson(
        KGetSalesLeadsResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.leads?.map((e) => e.toJson()).toList() case final value?)
        'leads': value,
    };
