// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'klat_lng.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KLatLng _$KLatLngFromJson(Map<String, dynamic> json) => KLatLng()
  ..lat = double.parse(json['lat'] as String)
  ..lng = double.parse(json['lng'] as String);

Map<String, dynamic> _$KLatLngToJson(KLatLng instance) => <String, dynamic>{
      'lat': KStringHelper.dtoa(instance.lat),
      'lng': KStringHelper.dtoa(instance.lng),
    };
