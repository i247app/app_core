// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu()
  ..menuID = json['menuID'] as String?
  ..buid = json['buid'] as String?
  ..storeID = json['storeID'] as String?
  ..imageURL = json['imgURL'] as String?
  ..note = json['note'] as String?
  ..menuStatus = json['menuStatus'] as String?
  ..currencyCode = json['currencyCode'] as String?
  ..items = (json['menuItems'] as List<dynamic>?)
      ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..featured = (json['featureItems'] as List<dynamic>?)
      ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..business = json['business'] == null
      ? null
      : Business.fromJson(json['business'] as Map<String, dynamic>);

Map<String, dynamic> _$MenuToJson(Menu instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('menuID', instance.menuID);
  writeNotNull('buid', instance.buid);
  writeNotNull('storeID', instance.storeID);
  writeNotNull('imgURL', instance.imageURL);
  writeNotNull('note', instance.note);
  writeNotNull('menuStatus', instance.menuStatus);
  writeNotNull('currencyCode', instance.currencyCode);
  writeNotNull('menuItems', instance.items?.map((e) => e.toJson()).toList());
  writeNotNull(
      'featureItems', instance.featured?.map((e) => e.toJson()).toList());
  writeNotNull('business', instance.business?.toJson());
  return val;
}
