// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'klat_lng.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KLatLng _$KLatLngFromJson(Map<String, dynamic> json) => KLatLng()
  ..lat = double.parse(json['lat'] as String)
  ..lng = double.parse(json['lng'] as String);

Map<String, dynamic> _$KLatLngToJson(KLatLng instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('lat', KStringHelper.dtoa(instance.lat));
  writeNotNull('lng', KStringHelper.dtoa(instance.lng));
  return val;
}
