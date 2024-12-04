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

Map<String, dynamic> _$OrderSubitemToJson(OrderSubitem instance) =>
    <String, dynamic>{
      if (instance.menuID case final value?) 'menuID': value,
      if (instance.menuItemID case final value?) 'menuItemID': value,
      if (instance.menuSubItemID case final value?) 'menuSubitemID': value,
      if (instance.name case final value?) 'name': value,
      if (instance.price case final value?) 'price': value,
      if (instance.text case final value?) 'text': value,
      if (instance.subItemStatus case final value?) 'subitemStatus': value,
    };
