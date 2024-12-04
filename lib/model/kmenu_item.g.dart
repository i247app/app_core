// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kmenu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KMenuItem _$KMenuItemFromJson(Map<String, dynamic> json) => KMenuItem()
  ..menuID = json['menuID'] as String?
  ..menuItemID = json['menuItemID'] as String?
  ..name = json['name'] as String?
  ..text = json['text'] as String?
  ..code = json['code'] as String?
  ..price = json['price'] as String?
  ..imageURL = json['imgURL'] as String?
  ..imageData = json['imgData'] as String?
  ..status = json['itemStatus'] as String?
  ..categoryID = json['catID'] as String?
  ..categoryName = json['catName'] as String?
  ..smallPrice = json['smallPrice'] as String?
  ..mediumPrice = json['mediumPrice'] as String?
  ..largePrice = json['largePrice'] as String?
  ..subitems = (json['menuSubitems'] as List<dynamic>?)
      ?.map((e) => MenuSubitem.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$KMenuItemToJson(KMenuItem instance) => <String, dynamic>{
      if (instance.menuID case final value?) 'menuID': value,
      if (instance.menuItemID case final value?) 'menuItemID': value,
      if (instance.name case final value?) 'name': value,
      if (instance.text case final value?) 'text': value,
      if (instance.code case final value?) 'code': value,
      if (instance.price case final value?) 'price': value,
      if (instance.imageURL case final value?) 'imgURL': value,
      if (instance.imageData case final value?) 'imgData': value,
      if (instance.status case final value?) 'itemStatus': value,
      if (instance.categoryID case final value?) 'catID': value,
      if (instance.categoryName case final value?) 'catName': value,
      if (instance.smallPrice case final value?) 'smallPrice': value,
      if (instance.mediumPrice case final value?) 'mediumPrice': value,
      if (instance.largePrice case final value?) 'largePrice': value,
      if (instance.subitems?.map((e) => e.toJson()).toList() case final value?)
        'menuSubitems': value,
    };
