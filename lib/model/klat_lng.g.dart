// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'klat_lng.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCoreKLatLng _$AppCoreKLatLngFromJson(Map<String, dynamic> json) {
  return AppCoreKLatLng()
    ..lat = double.parse(json['lat'] as String)
    ..lng = double.parse(json['lng'] as String);
}

Map<String, dynamic> _$AppCoreKLatLngToJson(AppCoreKLatLng instance) =>
    <String, dynamic>{
      'lat': AppCoreStringHelper.dtoa(instance.lat),
      'lng': AppCoreStringHelper.dtoa(instance.lng),
    };
