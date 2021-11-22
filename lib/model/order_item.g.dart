// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem()
  ..orderID = json['orderID'] as String?
  ..orderItemID = json['orderItemID'] as String?
  ..menuID = json['menuID'] as String?
  ..menuItemID = json['menuItemID'] as String?
  ..name = json['name'] as String?
  ..text = json['text'] as String?
  ..imageURL = json['imgURL'] as String?
  ..price = json['price'] as String?
  ..quantity = json['quantity'] as String?
  ..itemNote = json['itemNote'] as String?
  ..itemStatus = json['itemStatus'] as String?
  ..smallPrice = json['smallPrice'] as String?
  ..mediumPrice = json['mediumPrice'] as String?
  ..largePrice = json['largePrice'] as String?
  ..subItems = (json['orderSubitems'] as List<dynamic>?)
      ?.map((e) => OrderSubitem.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('orderID', instance.orderID);
  writeNotNull('orderItemID', instance.orderItemID);
  writeNotNull('menuID', instance.menuID);
  writeNotNull('menuItemID', instance.menuItemID);
  writeNotNull('name', instance.name);
  writeNotNull('text', instance.text);
  writeNotNull('imgURL', instance.imageURL);
  writeNotNull('price', instance.price);
  writeNotNull('quantity', instance.quantity);
  writeNotNull('itemNote', instance.itemNote);
  writeNotNull('itemStatus', instance.itemStatus);
  writeNotNull('smallPrice', instance.smallPrice);
  writeNotNull('mediumPrice', instance.mediumPrice);
  writeNotNull('largePrice', instance.largePrice);
  writeNotNull(
      'orderSubitems', instance.subItems?.map((e) => e.toJson()).toList());
  return val;
}
