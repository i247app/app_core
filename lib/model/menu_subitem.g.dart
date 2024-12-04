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

Map<String, dynamic> _$MenuSubitemToJson(MenuSubitem instance) =>
    <String, dynamic>{
      if (instance.menuID case final value?) 'menuID': value,
      if (instance.menuItemID case final value?) 'menuItemID': value,
      if (instance.menuSubitemID case final value?) 'menuSubitemID': value,
      if (instance.buid case final value?) 'buid': value,
      if (instance.code case final value?) 'code': value,
      if (instance.name case final value?) 'name': value,
      if (instance.text case final value?) 'text': value,
      if (instance.price case final value?) 'price': value,
      if (instance.subitemStatus case final value?) 'subitemStatus': value,
      if (instance.subCategoryID case final value?) 'subcatID': value,
      if (instance.subCategoryName case final value?) 'subcatName': value,
    };
