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

Map<String, dynamic> _$KGigAddressToJson(KGigAddress instance) =>
    <String, dynamic>{
      if (instance.addressID case final value?) 'addressID': value,
      if (instance.puid case final value?) 'puid': value,
      if (instance.placeID case final value?) 'placeID': value,
      if (instance.addressType case final value?) 'addressType': value,
      if (instance.addressLine1 case final value?) 'addressLine1': value,
      if (instance.addressLine2 case final value?) 'addressLine2': value,
      if (instance.addressLine case final value?) 'addressLine': value,
      if (instance.placeName case final value?) 'placeName': value,
      if (instance.ward case final value?) 'ward': value,
      if (instance.district case final value?) 'district': value,
      if (instance.city case final value?) 'city': value,
      if (instance.stateCode case final value?) 'stateCode': value,
      if (instance.zipCode case final value?) 'zipCode': value,
      if (instance.countryCode case final value?) 'countryCode': value,
      if (instance.addressStatus case final value?) 'addressStatus': value,
      if (instance.latLng?.toJson() case final value?) 'latLng': value,
      if (instance.gigID case final value?) 'gigID': value,
      if (instance.locationType case final value?) 'locationType': value,
      if (instance.locationNumber case final value?) 'locationNumber': value,
    };
