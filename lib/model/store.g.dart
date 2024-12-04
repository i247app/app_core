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

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      if (instance.buid case final value?) 'buid': value,
      if (instance.storeID case final value?) 'storeID': value,
      if (instance.storeNO case final value?) 'storeNO': value,
      if (instance.storeName case final value?) 'storeName': value,
      if (instance.email case final value?) 'email': value,
      if (instance.fone case final value?) 'fone': value,
      if (instance.foneCode case final value?) 'foneCode': value,
      if (instance.dba case final value?) 'dba': value,
      if (instance.taxID case final value?) 'taxID': value,
      if (instance.menuID case final value?) 'menuID': value,
      if (instance.addressLine1 case final value?) 'addressLine1': value,
      if (instance.addressLine2 case final value?) 'addressLine2': value,
      if (instance.city case final value?) 'city': value,
      if (instance.stateCode case final value?) 'stateCode': value,
      if (instance.zipCode case final value?) 'zipCode': value,
      if (instance.countryCode case final value?) 'countryCode': value,
      if (instance.lat case final value?) 'lat': value,
      if (instance.lng case final value?) 'lng': value,
      if (instance.url case final value?) 'url': value,
      if (instance.slogan case final value?) 'slogan': value,
      if (instance.description case final value?) 'shortDesc': value,
      if (instance.info case final value?) 'info': value,
      if (instance.imageURL case final value?) 'imgURL': value,
      if (instance.imageData case final value?) 'imgData': value,
      if (instance.keywords case final value?) 'ftsWords': value,
      if (instance.estYear case final value?) 'estYear': value,
      if (instance.deliveryOpt case final value?) 'deliveryOpt': value,
      if (instance.pickupOpt case final value?) 'pickupOpt': value,
      if (instance.tableOpt case final value?) 'tableOpt': value,
      if (instance.categoryCode case final value?) 'catCode': value,
      if (instance.latLng?.toJson() case final value?) 'latLng': value,
      if (instance.rawIsOpen case final value?) 'isOpen': value,
      if (instance.storeHours?.map((e) => e.toJson()).toList()
          case final value?)
        'storeHours': value,
      if (instance.leadTime case final value?) 'leadTime': value,
      if (instance.minimumTotal case final value?) 'minimumTotal': value,
      if (instance.rawIsPrepay case final value?) 'isPrepay': value,
      if (instance.currencyCode case final value?) 'currencyCode': value,
    };
