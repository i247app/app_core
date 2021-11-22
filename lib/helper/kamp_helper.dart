import 'package:app_core/helper/kmath_helper.dart';
import 'package:app_core/model/menu.dart';
import 'package:app_core/model/order.dart';
import 'package:app_core/model/order_item.dart';
import 'package:app_core/model/order_subitem.dart';
import 'package:app_core/model/store.dart';

class AMPData {
  Store? store;
  Menu? menu;
  Order? order;

  String? get key => menu?.menuID; // cart key

  String? get buid => store?.buid;

  String? get storeID => store?.storeID;

  String? get currencyCode => menu?.currencyCode ?? store?.currencyCode;
}

abstract class AMPHelper {
  /// Calculate the total cost of an OrderItem
  static String calculateOrderItemTotal(OrderItem orderItem) {
    String result = "0";
    for (OrderSubitem osi in orderItem.subItems ?? [])
      result = KMathHelper.add(osi.price ?? "0", result);

    String sizePrice = "0";
    if ((double.tryParse(orderItem.smallPrice ?? "0") ?? 0) > 0)
      sizePrice = orderItem.smallPrice ?? "0";
    else if ((double.tryParse(orderItem.mediumPrice ?? "0") ?? 0) > 0)
      sizePrice = orderItem.mediumPrice ?? "0";
    else if ((double.tryParse(orderItem.largePrice ?? "0") ?? 0) > 0)
      sizePrice = orderItem.largePrice ?? "0";
    else
      sizePrice = orderItem.price ?? "0";

    return KMathHelper.mult(
      KMathHelper.add(result, sizePrice),
      orderItem.quantity ?? "0",
    );
  }
}
