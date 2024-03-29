// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kgig_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGigAddress _$KGigAddressFromJson(Map<String, dynamic> json) => KGigAddress()
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
      : KLatLng.fromJson(json['latLng'] as Map<String, dynamic>)
  ..gigID = json['gigID'] as String?
  ..locationType = json['locationType'] as String?
  ..locationNumber = json['locationNumber'] as String?;

Map<String, dynamic> _$KGigAddressToJson(KGigAddress instance) {
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
  writeNotNull('gigID', instance.gigID);
  writeNotNull('locationType', instance.locationType);
  writeNotNull('locationNumber', instance.locationNumber);
  return val;
}
