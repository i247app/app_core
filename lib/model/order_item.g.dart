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

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      if (instance.orderID case final value?) 'orderID': value,
      if (instance.orderItemID case final value?) 'orderItemID': value,
      if (instance.menuID case final value?) 'menuID': value,
      if (instance.menuItemID case final value?) 'menuItemID': value,
      if (instance.name case final value?) 'name': value,
      if (instance.text case final value?) 'text': value,
      if (instance.imageURL case final value?) 'imgURL': value,
      if (instance.price case final value?) 'price': value,
      if (instance.quantity case final value?) 'quantity': value,
      if (instance.itemNote case final value?) 'itemNote': value,
      if (instance.itemStatus case final value?) 'itemStatus': value,
      if (instance.smallPrice case final value?) 'smallPrice': value,
      if (instance.mediumPrice case final value?) 'mediumPrice': value,
      if (instance.largePrice case final value?) 'largePrice': value,
      if (instance.subItems?.map((e) => e.toJson()).toList() case final value?)
        'orderSubitems': value,
    };
