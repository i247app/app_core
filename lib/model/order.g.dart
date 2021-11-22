// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order()
  ..orderID = json['orderID'] as String?
  ..buid = json['buid'] as String?
  ..storeID = json['storeID'] as String?
  ..storeNO = json['storeNO'] as String?
  ..cuid = json['cuid'] as String?
  ..menuID = json['menuID'] as String?
  ..currencyCode = json['currencyCode'] as String?
  ..orderDate = json['orderDate'] as String?
  ..orderType = json['orderType'] as String?
  ..tableID = json['tableID'] as String?
  ..orderNote = json['orderNote'] as String?
  ..orderStatus = json['orderStatus'] as String?
  ..orderStatusDate = json['orderStatusDate'] as String?
  ..leadTime = json['leadTime'] as String?
  ..minimumTotal = json['minimumTotal'] as String?
  ..reserveDate = zzz_str2Date(json['reserveDate'] as String?)
  ..subtotal = json['subtotal'] as String?
  ..tax = json['tax'] as String?
  ..deliveryFee = json['deliveryFee'] as String?
  ..serviceFee = json['serviceFee'] as String?
  ..promoCode = json['promoCode'] as String?
  ..promoValue = json['promoValue'] as String?
  ..adjustAmount = json['adjustAmount'] as String?
  ..total = json['total'] as String?
  ..payType = json['payType'] as String?
  ..payAccount = json['payAccount'] as String?
  ..payStatus = json['payStatus'] as String?
  ..payNote = json['payNote'] as String?
  ..sharedToSocialMedia = json['sharedToSocial'] as String?
  ..businessName = json['businessName'] as String?
  ..businessFoneCode = json['businessFoneCode'] as String?
  ..businessFone = json['businessFone'] as String?
  ..businessAddress = json['businessAddress'] as String?
  ..orderName = json['orderName'] as String?
  ..orderFoneCode = json['orderFoneCode'] as String?
  ..orderFone = json['orderFone'] as String?
  ..orderAddress = json['orderAddress'] as String?
  ..orderAddress2 = json['orderAddress2'] as String?
  ..orderLatLng = json['orderLatLng'] == null
      ? null
      : KLatLng.fromJson(json['orderLatLng'] as Map<String, dynamic>)
  ..items = (json['orderItems'] as List<dynamic>?)
      ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..business = json['business'] == null
      ? null
      : Business.fromJson(json['business'] as Map<String, dynamic>)
  ..user = json['user'] == null
      ? null
      : KUser.fromJson(json['user'] as Map<String, dynamic>)
  ..promoStatusMessage = json['promoStatusMessage'] as String?
  ..costSummaryItems = (json['costSummary'] as List<dynamic>?)
      ?.map((e) => CostSummaryItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..rawIsPrepay = json['isPrepay'] as String?
  ..rawIsCheckIn = json['isCheckIn'] as String?
  ..checkInDate = json['checkInDate'] as String?;

Map<String, dynamic> _$OrderToJson(Order instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('orderID', instance.orderID);
  writeNotNull('buid', instance.buid);
  writeNotNull('storeID', instance.storeID);
  writeNotNull('storeNO', instance.storeNO);
  writeNotNull('cuid', instance.cuid);
  writeNotNull('menuID', instance.menuID);
  writeNotNull('currencyCode', instance.currencyCode);
  writeNotNull('orderDate', instance.orderDate);
  writeNotNull('orderType', instance.orderType);
  writeNotNull('tableID', instance.tableID);
  writeNotNull('orderNote', instance.orderNote);
  writeNotNull('orderStatus', instance.orderStatus);
  writeNotNull('orderStatusDate', instance.orderStatusDate);
  writeNotNull('leadTime', instance.leadTime);
  writeNotNull('minimumTotal', instance.minimumTotal);
  writeNotNull('reserveDate', zzz_date2Str(instance.reserveDate));
  writeNotNull('subtotal', instance.subtotal);
  writeNotNull('tax', instance.tax);
  writeNotNull('deliveryFee', instance.deliveryFee);
  writeNotNull('serviceFee', instance.serviceFee);
  writeNotNull('promoCode', instance.promoCode);
  writeNotNull('promoValue', instance.promoValue);
  writeNotNull('adjustAmount', instance.adjustAmount);
  writeNotNull('total', instance.total);
  writeNotNull('payType', instance.payType);
  writeNotNull('payAccount', instance.payAccount);
  writeNotNull('payStatus', instance.payStatus);
  writeNotNull('payNote', instance.payNote);
  writeNotNull('sharedToSocial', instance.sharedToSocialMedia);
  writeNotNull('businessName', instance.businessName);
  writeNotNull('businessFoneCode', instance.businessFoneCode);
  writeNotNull('businessFone', instance.businessFone);
  writeNotNull('businessAddress', instance.businessAddress);
  writeNotNull('orderName', instance.orderName);
  writeNotNull('orderFoneCode', instance.orderFoneCode);
  writeNotNull('orderFone', instance.orderFone);
  writeNotNull('orderAddress', instance.orderAddress);
  writeNotNull('orderAddress2', instance.orderAddress2);
  writeNotNull('orderLatLng', instance.orderLatLng?.toJson());
  writeNotNull('orderItems', instance.items?.map((e) => e.toJson()).toList());
  writeNotNull('business', instance.business?.toJson());
  writeNotNull('user', instance.user?.toJson());
  writeNotNull('promoStatusMessage', instance.promoStatusMessage);
  writeNotNull('costSummary',
      instance.costSummaryItems?.map((e) => e.toJson()).toList());
  writeNotNull('isPrepay', instance.rawIsPrepay);
  writeNotNull('isCheckIn', instance.rawIsCheckIn);
  writeNotNull('checkInDate', instance.checkInDate);
  return val;
}
