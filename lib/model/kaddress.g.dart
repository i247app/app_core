// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kaddress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KAddress _$KAddressFromJson(Map<String, dynamic> json) => KAddress()
  ..addressID = json['addressID'] as String?
  ..puid = json['puid'] as String?
  ..placeID = json['placeID'] as String?
  ..addressType = json['addressType'] as String?
  ..addressLine1 = json['addressLine1'] as String?
  ..addressLine2 = json['addressLine2'] as String?
  ..addressLine = json['addressLine'] as String?
  ..placeName = json['placeName'] as String?
  ..ward = json['ward'] as String?
  ..district = json['district'] as String?
  ..city = json['city'] as String?
  ..stateCode = json['stateCode'] as String?
  ..zipCode = json['zipCode'] as String?
  ..countryCode = json['countryCode'] as String?
  ..addressStatus = json['addressStatus'] as String?
  ..latLng = json['latLng'] == null
      ? null
      : KLatLng.fromJson(json['latLng'] as Map<String, dynamic>);

Map<String, dynamic> _$KAddressToJson(KAddress instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('addressID', instance.addressID);
  writeNotNull('puid', instance.puid);
  writeNotNull('placeID', instance.placeID);
  writeNotNull('addressType', instance.addressType);
  writeNotNull('addressLine1', instance.addressLine1);
  writeNotNull('addressLine2', instance.addressLine2);
  writeNotNull('addressLine', instance.addressLine);
  writeNotNull('placeName', instance.placeName);
  writeNotNull('ward', instance.ward);
  writeNotNull('district', instance.district);
  writeNotNull('city', instance.city);
  writeNotNull('stateCode', instance.stateCode);
  writeNotNull('zipCode', instance.zipCode);
  writeNotNull('countryCode', instance.countryCode);
  writeNotNull('addressStatus', instance.addressStatus);
  writeNotNull('latLng', instance.latLng?.toJson());
  return val;
}
