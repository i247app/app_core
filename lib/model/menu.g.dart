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
      ?.map((e) => KMenuItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..featured = (json['featureItems'] as List<dynamic>?)
      ?.map((e) => KMenuItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..business = json['business'] == null
      ? null
      : Business.fromJson(json['business'] as Map<String, dynamic>);

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      if (instance.menuID case final value?) 'menuID': value,
      if (instance.buid case final value?) 'buid': value,
      if (instance.storeID case final value?) 'storeID': value,
      if (instance.imageURL case final value?) 'imgURL': value,
      if (instance.note case final value?) 'note': value,
      if (instance.menuStatus case final value?) 'menuStatus': value,
      if (instance.currencyCode case final value?) 'currencyCode': value,
      if (instance.items?.map((e) => e.toJson()).toList() case final value?)
        'menuItems': value,
      if (instance.featured?.map((e) => e.toJson()).toList() case final value?)
        'featureItems': value,
      if (instance.business?.toJson() case final value?) 'business': value,
    };
