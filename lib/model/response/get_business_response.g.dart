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

Map<String, dynamic> _$GetBusinessResponseToJson(GetBusinessResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('business', instance.business?.toJson());
  return val;
}
