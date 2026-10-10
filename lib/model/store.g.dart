// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store()
  ..buid = json['buid'] as String?
  ..storeID = json['storeID'] as String?
  ..storeNO = json['storeNO'] as String?
  ..storeName = json['storeName'] as String?
  ..email = json['email'] as String?
  ..fone = json['fone'] as String?
  ..foneCode = json['foneCode'] as String?
  ..dba = json['dba'] as String?
  ..taxID = json['taxID'] as String?
  ..menuID = json['menuID'] as String?
  ..addressLine1 = json['addressLine1'] as String?
  ..addressLine2 = json['addressLine2'] as String?
  ..city = json['city'] as String?
  ..stateCode = json['stateCode'] as String?
  ..zipCode = json['zipCode'] as String?
  ..countryCode = json['countryCode'] as String?
  ..lat = json['lat'] as String?
  ..lng = json['lng'] as String?
  ..url = json['url'] as String?
  ..slogan = json['slogan'] as String?
  ..description = json['shortDesc'] as String?
  ..info = json['info'] as String?
  ..imageURL = json['imgURL'] as String?
  ..imageData = json['imgData'] as String?
  ..keywords = json['ftsWords'] as String?
  ..estYear = json['estYear'] as String?
  ..deliveryOpt = json['deliveryOpt'] as String?
  ..pickupOpt = json['pickupOpt'] as String?
  ..tableOpt = json['tableOpt'] as String?
  ..categoryCode = json['catCode'] as String?
  ..latLng = json['latLng'] == null
      ? null
      : KLatLng.fromJson(json['latLng'] as Map<String, dynamic>)
  ..rawIsOpen = json['isOpen'] as String?
  ..storeHours = (json['storeHours'] as List<dynamic>?)
      ?.map((e) => KStoreHour.fromJson(e as Map<String, dynamic>))
      .toList()
  ..leadTime = json['leadTime'] as String?
  ..minimumTotal = json['minimumTotal'] as String?
  ..rawIsPrepay = json['isPrepay'] as String?
  ..currencyCode = json['currencyCode'] as String?;

Map<String, dynamic> _$StoreToJson(Store instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('buid', instance.buid);
  writeNotNull('storeID', instance.storeID);
  writeNotNull('storeNO', instance.storeNO);
  writeNotNull('storeName', instance.storeName);
  writeNotNull('email', instance.email);
  writeNotNull('fone', instance.fone);
  writeNotNull('foneCode', instance.foneCode);
  writeNotNull('dba', instance.dba);
  writeNotNull('taxID', instance.taxID);
  writeNotNull('menuID', instance.menuID);
  writeNotNull('addressLine1', instance.addressLine1);
  writeNotNull('addressLine2', instance.addressLine2);
  writeNotNull('city', instance.city);
  writeNotNull('stateCode', instance.stateCode);
  writeNotNull('zipCode', instance.zipCode);
  writeNotNull('countryCode', instance.countryCode);
  writeNotNull('lat', instance.lat);
  writeNotNull('lng', instance.lng);
  writeNotNull('url', instance.url);
  writeNotNull('slogan', instance.slogan);
  writeNotNull('shortDesc', instance.description);
  writeNotNull('info', instance.info);
  writeNotNull('imgURL', instance.imageURL);
  writeNotNull('imgData', instance.imageData);
  writeNotNull('ftsWords', instance.keywords);
  writeNotNull('estYear', instance.estYear);
  writeNotNull('deliveryOpt', instance.deliveryOpt);
  writeNotNull('pickupOpt', instance.pickupOpt);
  writeNotNull('tableOpt', instance.tableOpt);
  writeNotNull('catCode', instance.categoryCode);
  writeNotNull('latLng', instance.latLng?.toJson());
  writeNotNull('isOpen', instance.rawIsOpen);
  writeNotNull(
      'storeHours', instance.storeHours?.map((e) => e.toJson()).toList());
  writeNotNull('leadTime', instance.leadTime);
  writeNotNull('minimumTotal', instance.minimumTotal);
  writeNotNull('isPrepay', instance.rawIsPrepay);
  writeNotNull('currencyCode', instance.currencyCode);
  return val;
}
