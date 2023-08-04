// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_subitem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuSubitem _$MenuSubitemFromJson(Map<String, dynamic> json) => MenuSubitem()
  ..menuID = json['menuID'] as String?
  ..menuItemID = json['menuItemID'] as String?
  ..menuSubitemID = json['menuSubitemID'] as String?
  ..buid = json['buid'] as String?
  ..code = json['code'] as String?
  ..name = json['name'] as String?
  ..text = json['text'] as String?
  ..price = json['price'] as String?
  ..subitemStatus = json['subitemStatus'] as String?
  ..subCategoryID = json['subcatID'] as String?
  ..subCategoryName = json['subcatName'] as String?;

Map<String, dynamic> _$MenuSubitemToJson(MenuSubitem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('menuID', instance.menuID);
  writeNotNull('menuItemID', instance.menuItemID);
  writeNotNull('menuSubitemID', instance.menuSubitemID);
  writeNotNull('buid', instance.buid);
  writeNotNull('code', instance.code);
  writeNotNull('name', instance.name);
  writeNotNull('text', instance.text);
  writeNotNull('price', instance.price);
  writeNotNull('subitemStatus', instance.subitemStatus);
  writeNotNull('subcatID', instance.subCategoryID);
  writeNotNull('subcatName', instance.subCategoryName);
  return val;
}
