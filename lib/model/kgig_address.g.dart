// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kgig_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGigAddress _$KGigAddressFromJson(Map<String, dynamic> json) => KGigAddress()
  ..addressID = json['addressID'] as String?
  ..puid = json['puid'] as String?
  ..gigID = json['gigID'] as String?
  ..placeID = json['placeID'] as String?
  ..addressType = json['addressType'] as String?
  ..locationType = json['locationType'] as String?
  ..locationNumber = json['locationNumber'] as String?
  ..addressLine1 = json['addressLine1'] as String?
  ..addressLine2 = json['addressLine2'] as String?
  ..fullAddressLine = json['fullAddressLine'] as String?
  ..name = json['name'] as String?
  ..ward = json['ward'] as String?
  ..district = json['district'] as String?
  ..city = json['city'] as String?
  ..state = json['state'] as String?
  ..zipCode = json['zipCode'] as String?
  ..countryCode = json['countryCode'] as String?
  ..addressStatus = json['addressStatus'] as String?
  ..latLng = json['latLng'] == null
      ? null
      : KLatLng.fromJson(json['latLng'] as Map<String, dynamic>);

Map<String, dynamic> _$KGigAddressToJson(KGigAddress instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('addressID', instance.addressID);
  writeNotNull('puid', instance.puid);
  writeNotNull('gigID', instance.gigID);
  writeNotNull('placeID', instance.placeID);
  writeNotNull('addressType', instance.addressType);
  writeNotNull('locationType', instance.locationType);
  writeNotNull('locationNumber', instance.locationNumber);
  writeNotNull('addressLine1', instance.addressLine1);
  writeNotNull('addressLine2', instance.addressLine2);
  writeNotNull('fullAddressLine', instance.fullAddressLine);
  writeNotNull('name', instance.name);
  writeNotNull('ward', instance.ward);
  writeNotNull('district', instance.district);
  writeNotNull('city', instance.city);
  writeNotNull('state', instance.state);
  writeNotNull('zipCode', instance.zipCode);
  writeNotNull('countryCode', instance.countryCode);
  writeNotNull('addressStatus', instance.addressStatus);
  writeNotNull('latLng', instance.latLng?.toJson());
  return val;
}
