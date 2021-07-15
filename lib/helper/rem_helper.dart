import 'dart:convert';

import 'package:app_core/helper/globals.dart';
import 'package:app_core/helper/globals.dart';
import 'package:app_core/helper/scan_helper.dart';
import 'package:app_core/rem/mgr/rem_dispatcher.dart';
import 'package:app_core/rem/rem.dart';

abstract class AppCoreREMHelper {
  /// Run string through REM
  static AppCoreREMAction? from(String remData, [String? tag]) {
    AppCoreREMAction? action;

    try {
      Map<String, dynamic> data = json.decode(remData);
      String path = data[AppCoreREM.APP] ?? data['act'] ?? data['qr'];

      print("REM - $remData");
      action = AppCoreREMDispatcher().dispatch(path, data);
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
  static Future<void> scanREM() async {
    AppCoreScanResult result = await AppCoreScanHelper.scan();
    if (result.status == AppCoreScanStatus.ok && result.data != null && from(result.data!) != null)
      await from(result.data!)!.call(appCoreNavigatorKey.currentState!);
    else
      print(result.status);
  }
}
