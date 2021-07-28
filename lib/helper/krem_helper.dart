import 'dart:convert';

import 'package:app_core/helper/kglobals.dart';
import 'package:app_core/helper/kscan_helper.dart';
import 'package:app_core/rem/mgr/krem_manager.dart';
import 'package:app_core/rem/krem.dart';

abstract class KREMHelper {
  /// Run string through REM
  static KREMAction? from(KREMManager dispatcher, String remData,
      [String? tag]) {
    KREMAction? action;

    try {
      Map<String, dynamic> data = json.decode(remData);
      String path = data[KREM.APP] ?? data['act'] ?? data['qr'];

      print("REM - $remData");
      action = dispatcher.dispatch(path, data);
    } catch (e) {
      print(e.toString());
    }

    // uncomment for development
    // if (action == null && StringHelper.isExist(remData)) {
    //   ToastHelper.show(remData);
    // }

    return action;
  }

  /// Scan and attempt to pass result through REM
  static Future<void> scanREM(KREMManager dispatcher) async {
    KScanResult result = await KScanHelper.scan();
    if (result.status == KScanStatus.ok &&
        result.data != null &&
        from(dispatcher, result.data!) != null)
      await from(dispatcher, result.data!)!.call(kNavigatorKey.currentState!);
    else
      print(result.status);
  }
}
