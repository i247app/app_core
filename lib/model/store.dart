import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kmath_helper.dart';
import 'package:app_core/model/kstore_hour.dart';
import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable()
class Store {
  static const String BUID = "buid";
  static const String STORE_ID = "storeID";
  static const String EMAIL = "email";
  static const String FONE = "fone";
  static const String FONE_CODE = "foneCode";
  static const String STORE_NO = "storeNO";
  static const String STORE_NAME = "storeName";
  static const String DBA = "dba";
  static const String TAX_ID = "taxID";
  static const String MENU_ID = "menuID";
  static const String ADDRESS_LINE1 = "addressLine1";
  static const String ADDRESS_LINE2 = "addressLine2";
  static const String CITY = "city";
  static const String STATE_CODE = "stateCode";
  static const String ZIP_CODE = "zipCode";
  static const String COUNTRY_CODE = "countryCode";
  static const String LAT = "lat";
  static const String LNG = "lng";
  static const String URL = "url";
  static const String SLOGAN = "slogan";
  static const String SHORT_DESC = "shortDesc";
  static const String INFO = "info";
  static const String IMAGE_URL = "imgURL";
  static const String IMAGE_DATA = "imgData";
  static const String FTS_WORDS = "ftsWords";
  static const String ESTABLISH_YEAR = "estYear";
  static const String IS_OPEN = "isOpen";
  static const String IS_PREPAY = "isPrepay";
  static const String CURRENCY_CODE = "currencyCode";

  static const String LEAD_TIME = "leadTime";
  static const String MINIMUM_TOTAL = "minimumTotal";

  static const String DELIVERY_OPT = "deliveryOpt";
  static const String PICKUP_OPT = "pickupOpt";
  static const String TABLE_OPT = "tableOpt";

  static const String STORE_CAT_CODE_RESTAURANT = "FOOD";
  static const String STORE_CAT_CODE_STALL = "STALL";
  static const String STORE_CAT_CODE_TRUCK = "FOOD_TRUCK";
  static const String STORE_CAT_CODE_OTHER = "OTHER";

  @JsonKey(name: BUID)
  String? buid;

  @JsonKey(name: STORE_ID)
  String? storeID;

  @JsonKey(name: STORE_NO)
  String? storeNO;

  @JsonKey(name: STORE_NAME)
  String? storeName;

  @JsonKey(name: EMAIL)
  String? email;

  @JsonKey(name: FONE)
  String? fone;

  @JsonKey(name: FONE_CODE)
  String? foneCode;

  @JsonKey(name: DBA)
  String? dba;

  @JsonKey(name: TAX_ID)
  String? taxID;

  @JsonKey(name: MENU_ID)
  String? menuID;

  @JsonKey(name: ADDRESS_LINE1)
  String? addressLine1;

  @JsonKey(name: ADDRESS_LINE2)
  String? addressLine2;

  @JsonKey(name: CITY)
  String? city;

  @JsonKey(name: STATE_CODE)
  String? stateCode;

  @JsonKey(name: ZIP_CODE)
  String? zipCode;

  @JsonKey(name: COUNTRY_CODE)
  String? countryCode;

  @JsonKey(name: LAT)
  String? lat;

  @JsonKey(name: LNG)
  String? lng;

  @JsonKey(name: URL)
  String? url;

  @JsonKey(name: SLOGAN)
  String? slogan;

  @JsonKey(name: SHORT_DESC)
  String? description;

  @JsonKey(name: INFO)
  String? info;

  @JsonKey(name: IMAGE_URL)
  String? imageURL;

  @JsonKey(name: IMAGE_DATA)
  String? imageData;

  @JsonKey(name: FTS_WORDS)
  String? keywords;

  @JsonKey(name: ESTABLISH_YEAR)
  String? estYear;

  @JsonKey(name: DELIVERY_OPT)
  String? deliveryOpt;

  @JsonKey(name: PICKUP_OPT)
  String? pickupOpt;

  @JsonKey(name: TABLE_OPT)
  String? tableOpt;

  @JsonKey(name: "catCode")
  String? categoryCode;

  @JsonKey(name: "latLng")
  KLatLng? latLng;

  @JsonKey(name: IS_OPEN)
  String? rawIsOpen;

  @JsonKey(name: "storeHours")
  List<KStoreHour>? storeHours;

  @JsonKey(name: LEAD_TIME)
  String? leadTime;

  @JsonKey(name: MINIMUM_TOTAL)
  String? minimumTotal;

  @JsonKey(name: IS_PREPAY)
  String? rawIsPrepay;

  @JsonKey(name: CURRENCY_CODE)
  String? currencyCode;

  /// Get
  @JsonKey(ignore: true)
  bool get isOpen => KStringHelper.parseBoolean(this.rawIsOpen ?? "");

  @JsonKey(ignore: true)
  bool get isPrepay => KStringHelper.parseBoolean(this.rawIsPrepay ?? "");

  @JsonKey(ignore: true)
  bool get isPreOrder => parsedLeadTime > 0;

  @JsonKey(ignore: true)
  int get parsedLeadTime => KMathHelper.parseInt(leadTime ?? "");

  @JsonKey(ignore: true)
  int get parsedMinimumTotal => KMathHelper.parseInt(minimumTotal ?? "");

  @JsonKey(ignore: true)
  String get prettyFone =>
      KUtil.prettyFone(foneCode: foneCode ?? "", number: fone ?? "");

  // JSON
  Store();

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
