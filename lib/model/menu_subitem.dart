import 'package:json_annotation/json_annotation.dart';

part 'menu_subitem.g.dart';

@JsonSerializable()
class MenuSubitem {
  static const String MENU_ID = "menuID";
  static const String MENU_ITEM_ID = "menuItemID";
  static const String MENU_SUBITEM_ID = "menuSubitemID";
  static const String BUID = "buid";
  static const String CODE = "code";
  static const String NAME = "name";

  // static const String DESCRIPTION         = "description";
  static const String PRICE = "price";
  static const String TEXT = "text";
  static const String SUBITEM_STATUS = "subitemStatus";
  static const String SUBCATEGORY_ID = "subcatID";
  static const String SUBCATEGORY_NAME = "subcatName";

  @JsonKey(name: MENU_ID)
  String? menuID;

  @JsonKey(name: MENU_ITEM_ID)
  String? menuItemID;

  @JsonKey(name: MENU_SUBITEM_ID)
  String? menuSubitemID;

  @JsonKey(name: BUID)
  String? buid;

  @JsonKey(name: CODE)
  String? code;

  @JsonKey(name: NAME)
  String? name;

  // @JsonKey(name:DESCRIPTION)
  //  String description;

  @JsonKey(name: TEXT)
  String? text;

  @JsonKey(name: PRICE)
  String? price;

  @JsonKey(name: SUBITEM_STATUS)
  String? subitemStatus;

  @JsonKey(name: SUBCATEGORY_ID)
  String? subCategoryID;

  @JsonKey(name: SUBCATEGORY_NAME)
  String? subCategoryName;

  // JSON
  MenuSubitem();

  factory MenuSubitem.fromJson(Map<String, dynamic> json) =>
      _$MenuSubitemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuSubitemToJson(this);
}
