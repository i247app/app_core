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

Map<String, dynamic> _$BusinessToJson(Business instance) => <String, dynamic>{
      if (instance.puid case final value?) 'puid': value,
      if (instance.kuid case final value?) 'kuid': value,
      if (instance.buid case final value?) 'buid': value,
      if (instance.tokenName case final value?) 'tokenName': value,
      if (instance.bnm case final value?) 'businessName': value,
      if (instance.fone case final value?) 'fone': value,
      if (instance.foneCode case final value?) 'foneCode': value,
      if (instance.addressLine1 case final value?) 'addressLine1': value,
      if (instance.city case final value?) 'city': value,
      if (instance.countryCode case final value?) 'countryCode': value,
      if (instance.url case final value?) 'url': value,
      if (instance.description case final value?) 'shortDesc': value,
      if (instance.lat case final value?) 'lat': value,
      if (instance.lng case final value?) 'lng': value,
      if (instance.imageURL case final value?) 'imageURL': value,
      if (instance.imageData case final value?) 'imageData': value,
      if (instance.categoryCode case final value?) 'catCode': value,
      if (instance.stores?.map((e) => e.toJson()).toList() case final value?)
        'stores': value,
      if (instance.latLng?.toJson() case final value?) 'latLng': value,
      if (instance.deliveryOpt case final value?) 'deliveryOpt': value,
      if (instance.pickupOpt case final value?) 'pickupOpt': value,
      if (instance.tableOpt case final value?) 'tableOpt': value,
    };
