import 'package:app_core/model/business.dart';
import 'package:app_core/model/menu_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  static const String MENU_ID = "menuID";
  static const String BUID = "buid";
  static const String STORE_ID = "storeID";
  static const String IMG_URL = "imgURL";
  static const String NOTE = "note";
  static const String MENU_STATUS = "menuStatus";
  static const String CURRENCY_CODE = "currencyCode";
  static const String BUSINESS = "business";
  static const String MENU_ITEMS = "menuItems";
  static const String FEATURED_ITEMS = "featureItems";

  @JsonKey(name: MENU_ID)
  String? menuID;

  @JsonKey(name: BUID)
  String? buid;

  @JsonKey(name: STORE_ID)
  String? storeID;

  @JsonKey(name: IMG_URL)
  String? imageURL;

  @JsonKey(name: NOTE)
  String? note;

  @JsonKey(name: MENU_STATUS)
  String? menuStatus;

  @JsonKey(name: CURRENCY_CODE)
  String? currencyCode;

  @JsonKey(name: MENU_ITEMS)
  List<MenuItem>? items;

  @JsonKey(name: FEATURED_ITEMS)
  List<MenuItem>? featured;

  @JsonKey(name: BUSINESS)
  Business? business;

  // JSON
  Menu();

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
