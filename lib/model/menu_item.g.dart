// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => MenuItem()
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

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('menuID', instance.menuID);
  writeNotNull('menuItemID', instance.menuItemID);
  writeNotNull('name', instance.name);
  writeNotNull('text', instance.text);
  writeNotNull('code', instance.code);
  writeNotNull('price', instance.price);
  writeNotNull('imgURL', instance.imageURL);
  writeNotNull('imgData', instance.imageData);
  writeNotNull('itemStatus', instance.status);
  writeNotNull('catID', instance.categoryID);
  writeNotNull('catName', instance.categoryName);
  writeNotNull('smallPrice', instance.smallPrice);
  writeNotNull('mediumPrice', instance.mediumPrice);
  writeNotNull('largePrice', instance.largePrice);
  writeNotNull(
      'menuSubitems', instance.subitems?.map((e) => e.toJson()).toList());
  return val;
}
