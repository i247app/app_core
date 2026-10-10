// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_subitem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSubitem _$OrderSubitemFromJson(Map<String, dynamic> json) => OrderSubitem()
  ..menuID = json['menuID'] as String?
  ..menuItemID = json['menuItemID'] as String?
  ..menuSubItemID = json['menuSubitemID'] as String?
  ..name = json['name'] as String?
  ..price = json['price'] as String?
  ..text = json['text'] as String?
  ..subItemStatus = json['subitemStatus'] as String?;

Map<String, dynamic> _$OrderSubitemToJson(OrderSubitem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('menuID', instance.menuID);
  writeNotNull('menuItemID', instance.menuItemID);
  writeNotNull('menuSubitemID', instance.menuSubItemID);
  writeNotNull('name', instance.name);
  writeNotNull('price', instance.price);
  writeNotNull('text', instance.text);
  writeNotNull('subitemStatus', instance.subItemStatus);
  return val;
}
