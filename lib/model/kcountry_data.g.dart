// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kcountry_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KCountryData _$KCountryDataFromJson(Map<String, dynamic> json) => KCountryData()
  ..code = json['code'] as String
  ..label = json['label'] as String
  ..phoneCode = json['phoneCode'] as String;

Map<String, dynamic> _$KCountryDataToJson(KCountryData instance) =>
    <String, dynamic>{
      'code': instance.code,
      'label': instance.label,
      'phoneCode': instance.phoneCode,
    };
