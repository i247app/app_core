import 'package:app_core/model/menu_subitem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_subitem.g.dart';

@JsonSerializable()
class OrderSubitem {
  static const String MENU_ID = "menuID";
  static const String MENU_ITEM_ID = "menuItemID";
  static const String MENU_SUB_ITEM_ID = "menuSubitemID";
  static const String NAME = "name";
  static const String TEXT = "text";
  static const String PRICE = "price";
  static const String SUB_ITEM_STATUS = "subitemStatus";

  @JsonKey(name: MENU_ID)
  String? menuID;

  @JsonKey(name: MENU_ITEM_ID)
  String? menuItemID;

  @JsonKey(name: MENU_SUB_ITEM_ID)
  String? menuSubItemID;

  @JsonKey(name: NAME)
  String? name;

  @JsonKey(name: PRICE)
  String? price;

  @JsonKey(name: TEXT)
  String? text;

  @JsonKey(name: SUB_ITEM_STATUS)
  String? subItemStatus;

  factory OrderSubitem.fromMenuSubItem(MenuSubitem menuSubItem) =>
      OrderSubitem()
        ..menuID = menuSubItem.menuID
        ..menuItemID = menuSubItem.menuItemID ?? ""
        ..menuSubItemID = menuSubItem.menuSubitemID ?? ""
        ..name = menuSubItem.name ?? ""
        ..text = menuSubItem.text ?? ""
        ..price = menuSubItem.price ?? "0"
        ..subItemStatus = menuSubItem.subitemStatus;

  // JSON
  OrderSubitem();

  factory OrderSubitem.fromJson(Map<String, dynamic> json) =>
      _$OrderSubitemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSubitemToJson(this);
}
