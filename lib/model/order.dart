import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kmath_helper.dart';
import 'package:app_core/model/business.dart';
import 'package:app_core/model/cost_summary_item.dart';
import 'package:app_core/model/menu.dart';
import 'package:app_core/model/order_item.dart';
import 'package:app_core/model/store.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  static const String ORDER_ID = "orderID";
  static const String BUID = "buid";
  static const String STORE_ID = "storeID";
  static const String STORE_NO = "storeNO";
  static const String CUID = "cuid";

  static const String MENU_ID = "menuID";
  static const String CURRENCY_CODE = "currencyCode";

  static const String ORDER_DATE = "orderDate";
  static const String IS_PREPAY = "isPrepay";

  static const String IS_CHECK_IN = "isCheckIn";
  static const String CHECK_IN_DATE = "checkInDate";

  static const String ORDER_TYPE = "orderType";
  static const String TABLE_ID = "tableID";
  static const String ORDER_NOTE = "orderNote";
  static const String ORDER_STATUS = "orderStatus";
  static const String ORDER_STATUS_DATE = "orderStatusDate";

  static const String LEAD_TIME = "leadTime";
  static const String MINIMUM_TOTAL = "minimumTotal";
  static const String RESERVE_DATE = "reserveDate";
  static const String PROMO_STATUS_MESSAGE = "promoStatusMessage";

  static const String SUBTOTAL = "subtotal";
  static const String TAX = "tax";
  static const String DELIVERY_FEE = "deliveryFee";
  static const String SERVICE_FEE = "serviceFee";
  static const String PROMO_CODE = "promoCode";
  static const String PROMO_VALUE = "promoValue";
  static const String ADJUST_AMOUNT = "adjustAmount";
  static const String TOTAL = "total";

  static const String PAY_TYPE = "payType";
  static const String PAY_ACCOUNT = "payAccount";
  static const String PAY_STATUS = "payStatus";
  static const String PAY_NOTE = "payNote";

  static const String SHARED_TO_SOCIAL_MEDIA = "sharedToSocial";

  static const String ORDER_ITEMS = "orderItems";
  static const String COST_SUMMARY = "costSummary";

  static const String BUSINESS_NAME = "businessName";
  static const String BUSINESS_FONE_CODE = "businessFoneCode";
  static const String BUSINESS_FONE = "businessFone";
  static const String BUSINESS_ADDRESS = "businessAddress";

  static const String ORDER_NAME = "orderName";
  static const String ORDER_FONE_CODE = "orderFoneCode";
  static const String ORDER_FONE = "orderFone";
  static const String ORDER_ADDRESS = "orderAddress";
  static const String ORDER_ADDRESS2 = "orderAddress2";
  static const String ORDER_LAT_LNG = "orderLatLng";

  static const String BUSINESS = "business";
  static const String USER = "user";

  static const String TYPE_PICKUP = "PICKUP";
  static const String TYPE_DELIVERY = "DELIVERY";
  static const String TYPE_TABLE = "TABLE";

  static const String PAY_TYPE_CASH = "CASH";
  static const String PAY_TYPE_CARD = "CARD";
  static const String PAY_TYPE_CREDIT = "CREDIT";

  static const String PAY_STATUS_UNPAID = "UNPAID";
  static const String PAY_STATUS_PAID = "PAID";
  static const String PAY_STATUS_AUTH = "AUTH";
  static const String PAY_STATUS_REFUND = "REFUND";

  static const String STATUS_PENDING = "PENDING";
  static const String STATUS_ACCEPT = "ACCEPT";
  static const String STATUS_PREPARING = "PREPARING";
  static const String STATUS_ENROUTE = "ENROUTE";
  static const String STATUS_READY = "READY";
  static const String STATUS_COMPLETE = "COMPLETE";
  static const String STATUS_DONE = "DONE";
  static const String STATUS_CANCEL = "CANCEL";
  static const String STATUS_CANCELED = "CANCELED";

  @JsonKey(name: ORDER_ID)
  String? orderID;

  @JsonKey(name: BUID)
  String? buid;

  @JsonKey(name: STORE_ID)
  String? storeID;

  @JsonKey(name: STORE_NO)
  String? storeNO;

  @JsonKey(name: CUID)
  String? cuid;

  @JsonKey(name: MENU_ID)
  String? menuID;

  @JsonKey(name: CURRENCY_CODE)
  String? currencyCode;

  @JsonKey(name: ORDER_DATE)
  String? orderDate;

  @JsonKey(name: ORDER_TYPE)
  String? orderType;

  @JsonKey(name: TABLE_ID)
  String? tableID;

  @JsonKey(name: ORDER_NOTE)
  String? orderNote;

  @JsonKey(name: ORDER_STATUS)
  String? orderStatus;

  @JsonKey(name: ORDER_STATUS_DATE)
  String? orderStatusDate;

  @JsonKey(name: LEAD_TIME)
  String? leadTime;

  @JsonKey(name: MINIMUM_TOTAL)
  String? minimumTotal;

  @JsonKey(name: RESERVE_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? reserveDate;

  @JsonKey(name: SUBTOTAL)
  String? subtotal;

  @JsonKey(name: TAX)
  String? tax;

  @JsonKey(name: DELIVERY_FEE)
  String? deliveryFee;

  @JsonKey(name: SERVICE_FEE)
  String? serviceFee;

  @JsonKey(name: PROMO_CODE)
  String? promoCode;

  @JsonKey(name: PROMO_VALUE)
  String? promoValue;

  @JsonKey(name: ADJUST_AMOUNT)
  String? adjustAmount;

  @JsonKey(name: TOTAL)
  String? total;

  @JsonKey(name: PAY_TYPE)
  String? payType;

  @JsonKey(name: PAY_ACCOUNT)
  String? payAccount;

  @JsonKey(name: PAY_STATUS)
  String? payStatus;

  @JsonKey(name: PAY_NOTE)
  String? payNote;

  @JsonKey(name: SHARED_TO_SOCIAL_MEDIA)
  String? sharedToSocialMedia;

  @JsonKey(name: BUSINESS_NAME)
  String? businessName;

  @JsonKey(name: BUSINESS_FONE_CODE)
  String? businessFoneCode;

  @JsonKey(name: BUSINESS_FONE)
  String? businessFone;

  @JsonKey(name: BUSINESS_ADDRESS)
  String? businessAddress;

  @JsonKey(name: ORDER_NAME)
  String? orderName;

  @JsonKey(name: ORDER_FONE_CODE)
  String? orderFoneCode;

  @JsonKey(name: ORDER_FONE)
  String? orderFone;

  @JsonKey(name: ORDER_ADDRESS)
  String? orderAddress;

  @JsonKey(name: ORDER_ADDRESS2)
  String? orderAddress2;

  @JsonKey(name: ORDER_LAT_LNG)
  KLatLng? orderLatLng;

  @JsonKey(name: ORDER_ITEMS)
  List<OrderItem>? items;

  @JsonKey(name: BUSINESS)
  Business? business;

  @JsonKey(name: USER)
  KUser? user;

  @JsonKey(name: PROMO_STATUS_MESSAGE)
  String? promoStatusMessage;

  @JsonKey(name: COST_SUMMARY)
  List<CostSummaryItem>? costSummaryItems;

  @JsonKey(name: IS_PREPAY)
  String? rawIsPrepay;

  @JsonKey(name: IS_CHECK_IN)
  String? rawIsCheckIn;

  @JsonKey(name: CHECK_IN_DATE)
  String? checkInDate;

  @JsonKey(ignore: true)
  bool get isCheckIn => KStringHelper.parseBoolean(this.rawIsCheckIn ?? "");

  @JsonKey(ignore: true)
  bool get isPrepay => KStringHelper.parseBoolean(this.rawIsPrepay ?? "");

  /// Methods
  @JsonKey(ignore: true)
  int get parsedLeadTime => KMathHelper.parseInt(leadTime ?? "");

  @JsonKey(ignore: true)
  int get parsedMinimumTotal => KMathHelper.parseInt(minimumTotal ?? "");

  @JsonKey(ignore: true)
  String get prettyOrderFone => KUtil.prettyFone(
        foneCode: this.orderFoneCode ?? "",
        number: this.orderFone ?? "",
      );

  @JsonKey(ignore: true)
  String get prettyBizFone => KUtil.prettyFone(
        foneCode: this.businessFoneCode ?? "",
        number: this.businessFone ?? "",
      );

  void updateFromStore(Store store) {
    this.leadTime = store.leadTime;
    this.reserveDate = store.parsedLeadTime == 0
        ? null
        : KDateHelper.copy(
            DateTime.now().add(Duration(minutes: parsedLeadTime)),
            hour: 17,
            minute: 0,
            second: 0,
            millisecond: 0,
          );
    this.rawIsPrepay = store.rawIsPrepay;
    this.minimumTotal = store.minimumTotal;
    this.businessName = store.storeName;
    this.businessFoneCode = store.foneCode;
    this.businessFone = store.fone;
    this.businessAddress = store.addressLine1;
    this.storeID = store.storeID;
    this.storeNO = store.storeNO;
  }

  factory Order.fromMenu(Menu menu) => Order()
    ..menuID = menu.menuID
    ..storeID = menu.storeID
    ..buid = menu.buid
    // todo add currency code from menu by coping it
    ..currencyCode = menu.currencyCode
    ..items ??= [];

  // JSON
  Order();

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
