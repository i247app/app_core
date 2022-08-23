import 'package:app_core/model/kmenu_item.dart';
import 'package:app_core/model/order_subitem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItem {
  static const String ORDER_ID = "orderID";
  static const String ORDER_ITEM_ID = "orderItemID";
  static const String MENU_ID = "menuID";
  static const String MENU_ITEM_ID = "menuItemID";
  static const String NAME = "name";
  static const String TEXT = "text";
  static const String IMAGE_URL = "imgURL";
  static const String PRICE = "price";
  static const String QUANTITY = "quantity";
  static const String ITEM_NOTE = "itemNote";
  static const String ITEM_STATUS = "itemStatus";

  // TODO sizes perhaps into a json object
  static const String SMALL_PRICE = "smallPrice";
  static const String MEDIUM_PRICE = "mediumPrice";
  static const String LARGE_PRICE = "largePrice";

  static const String ORDER_SUB_ITEMS = "orderSubitems";

  @JsonKey(name: ORDER_ID)
  String? orderID;

  @JsonKey(name: ORDER_ITEM_ID)
  String? orderItemID;

  @JsonKey(name: MENU_ID)
  String? menuID;

  @JsonKey(name: MENU_ITEM_ID)
  String? menuItemID;

  @JsonKey(name: NAME)
  String? name;

  @JsonKey(name: TEXT)
  String? text;

  @JsonKey(name: IMAGE_URL)
  String? imageURL;

  @JsonKey(name: PRICE)
  String? price;

  @JsonKey(name: QUANTITY)
  String? quantity;

  @JsonKey(name: ITEM_NOTE)
  String? itemNote;

  @JsonKey(name: ITEM_STATUS)
  String? itemStatus;

  @JsonKey(name: SMALL_PRICE)
  String? smallPrice;

  @JsonKey(name: MEDIUM_PRICE)
  String? mediumPrice;

  @JsonKey(name: LARGE_PRICE)
  String? largePrice;

  @JsonKey(name: ORDER_SUB_ITEMS)
  List<OrderSubitem>? subItems;

  factory OrderItem.fromMenuItem(KMenuItem menuItem) => OrderItem()
    ..menuID = menuItem.menuID
    ..menuItemID = menuItem.menuItemID
    ..name = menuItem.name
    ..text = menuItem.text
    ..imageURL = menuItem.imageURL ?? ""
    ..price = menuItem.price ?? ""
    ..quantity = "1"
    ..subItems = [];

  // JSON
  OrderItem();

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
