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

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      if (instance.orderID case final value?) 'orderID': value,
      if (instance.buid case final value?) 'buid': value,
      if (instance.storeID case final value?) 'storeID': value,
      if (instance.storeNO case final value?) 'storeNO': value,
      if (instance.cuid case final value?) 'cuid': value,
      if (instance.menuID case final value?) 'menuID': value,
      if (instance.currencyCode case final value?) 'currencyCode': value,
      if (instance.orderDate case final value?) 'orderDate': value,
      if (instance.orderType case final value?) 'orderType': value,
      if (instance.tableID case final value?) 'tableID': value,
      if (instance.orderNote case final value?) 'orderNote': value,
      if (instance.orderStatus case final value?) 'orderStatus': value,
      if (instance.orderStatusDate case final value?) 'orderStatusDate': value,
      if (instance.leadTime case final value?) 'leadTime': value,
      if (instance.minimumTotal case final value?) 'minimumTotal': value,
      if (zzz_date2Str(instance.reserveDate) case final value?)
        'reserveDate': value,
      if (instance.subtotal case final value?) 'subtotal': value,
      if (instance.tax case final value?) 'tax': value,
      if (instance.deliveryFee case final value?) 'deliveryFee': value,
      if (instance.serviceFee case final value?) 'serviceFee': value,
      if (instance.promoCode case final value?) 'promoCode': value,
      if (instance.promoValue case final value?) 'promoValue': value,
      if (instance.adjustAmount case final value?) 'adjustAmount': value,
      if (instance.total case final value?) 'total': value,
      if (instance.payType case final value?) 'payType': value,
      if (instance.payAccount case final value?) 'payAccount': value,
      if (instance.payStatus case final value?) 'payStatus': value,
      if (instance.payNote case final value?) 'payNote': value,
      if (instance.sharedToSocialMedia case final value?)
        'sharedToSocial': value,
      if (instance.businessName case final value?) 'businessName': value,
      if (instance.businessFoneCode case final value?)
        'businessFoneCode': value,
      if (instance.businessFone case final value?) 'businessFone': value,
      if (instance.businessAddress case final value?) 'businessAddress': value,
      if (instance.orderName case final value?) 'orderName': value,
      if (instance.orderFoneCode case final value?) 'orderFoneCode': value,
      if (instance.orderFone case final value?) 'orderFone': value,
      if (instance.orderAddress case final value?) 'orderAddress': value,
      if (instance.orderAddress2 case final value?) 'orderAddress2': value,
      if (instance.orderLatLng?.toJson() case final value?)
        'orderLatLng': value,
      if (instance.items?.map((e) => e.toJson()).toList() case final value?)
        'orderItems': value,
      if (instance.business?.toJson() case final value?) 'business': value,
      if (instance.user?.toJson() case final value?) 'user': value,
      if (instance.promoStatusMessage case final value?)
        'promoStatusMessage': value,
      if (instance.costSummaryItems?.map((e) => e.toJson()).toList()
          case final value?)
        'costSummary': value,
      if (instance.rawIsPrepay case final value?) 'isPrepay': value,
      if (instance.rawIsCheckIn case final value?) 'isCheckIn': value,
      if (instance.checkInDate case final value?) 'checkInDate': value,
    };
