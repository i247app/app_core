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
    KGetSalesLeadsResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('leads', instance.leads?.map((e) => e.toJson()).toList());
  return val;
}
