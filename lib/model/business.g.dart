// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Business _$BusinessFromJson(Map<String, dynamic> json) => Business()
  ..puid = json['puid'] as String?
  ..kuid = json['kuid'] as String?
  ..buid = json['buid'] as String?
  ..tokenName = json['tokenName'] as String?
  ..bnm = json['businessName'] as String?
  ..fone = json['fone'] as String?
  ..foneCode = json['foneCode'] as String?
  ..addressLine1 = json['addressLine1'] as String?
  ..city = json['city'] as String?
  ..countryCode = json['countryCode'] as String?
  ..url = json['url'] as String?
  ..description = json['shortDesc'] as String?
  ..lat = json['lat'] as String?
  ..lng = json['lng'] as String?
  ..imageURL = json['imageURL'] as String?
  ..imageData = json['imageData'] as String?
  ..categoryCode = json['catCode'] as String?
  ..stores = (json['stores'] as List<dynamic>?)
      ?.map((e) => Store.fromJson(e as Map<String, dynamic>))
      .toList()
  ..latLng = json['latLng'] == null
      ? null
      : KLatLng.fromJson(json['latLng'] as Map<String, dynamic>)
  ..deliveryOpt = json['deliveryOpt'] as String?
  ..pickupOpt = json['pickupOpt'] as String?
  ..tableOpt = json['tableOpt'] as String?;

Map<String, dynamic> _$BusinessToJson(Business instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('puid', instance.puid);
  writeNotNull('kuid', instance.kuid);
  writeNotNull('buid', instance.buid);
  writeNotNull('tokenName', instance.tokenName);
  writeNotNull('businessName', instance.bnm);
  writeNotNull('fone', instance.fone);
  writeNotNull('foneCode', instance.foneCode);
  writeNotNull('addressLine1', instance.addressLine1);
  writeNotNull('city', instance.city);
  writeNotNull('countryCode', instance.countryCode);
  writeNotNull('url', instance.url);
  writeNotNull('shortDesc', instance.description);
  writeNotNull('lat', instance.lat);
  writeNotNull('lng', instance.lng);
  writeNotNull('imageURL', instance.imageURL);
  writeNotNull('imageData', instance.imageData);
  writeNotNull('catCode', instance.categoryCode);
  writeNotNull('stores', instance.stores?.map((e) => e.toJson()).toList());
  writeNotNull('latLng', instance.latLng?.toJson());
  writeNotNull('deliveryOpt', instance.deliveryOpt);
  writeNotNull('pickupOpt', instance.pickupOpt);
  writeNotNull('tableOpt', instance.tableOpt);
  return val;
}
