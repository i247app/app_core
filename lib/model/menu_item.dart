import 'package:app_core/model/menu_subitem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'menu_item.g.dart';

@JsonSerializable()
class MenuItem {
  static const String MENU_ID = "menuID";
  static const String MENU_ITEM_ID = "menuItemID";
  static const String CODE = "code";
  static const String NAME = "name";
  static const String TEXT = "text";
  static const String PRICE = "price";

  // TODO ITEM_SIZES = itemSizes
  //  List<ItemSize> itemSizes = [{"small":"4.95"}, {"medium":"5.95"}]
  static const String SMALL_PRICE = "smallPrice";
  static const String MEDIUM_PRICE = "mediumPrice";
  static const String LARGE_PRICE = "largePrice";

  static const String MENU_SUBITEMS = "menuSubitems";

  static const String STATUS = "itemStatus";
  static const String IMAGE_URL = "imgURL";
  static const String IMAGE_DATA = "imgData";
  static const String CATEGORY_ID = "catID";
  static const String CATEGORY_NAME = "catName";

  @JsonKey(name: MENU_ID)
  String? menuID;

  @JsonKey(name: MENU_ITEM_ID)
  String? menuItemID;

  @JsonKey(name: NAME)
  String? name;

  @JsonKey(name: TEXT)
  String? text;

  @JsonKey(name: CODE)
  String? code;

  @JsonKey(name: PRICE)
  String? price;

  @JsonKey(name: IMAGE_URL)
  String? imageURL;

  @JsonKey(name: IMAGE_DATA)
  String? imageData;

  @JsonKey(name: STATUS)
  String? status;

  @JsonKey(name: CATEGORY_ID)
  String? categoryID;

  @JsonKey(name: CATEGORY_NAME)
  String? categoryName;

  @JsonKey(name: SMALL_PRICE)
  String? smallPrice;

  @JsonKey(name: MEDIUM_PRICE)
  String? mediumPrice;

  @JsonKey(name: LARGE_PRICE)
  String? largePrice;

  @JsonKey(name: MENU_SUBITEMS)
  List<MenuSubitem>? subitems;

  // JSON
  MenuItem();

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}
