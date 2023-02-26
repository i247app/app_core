import 'dart:async';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

enum KScanStatus {
  ok,
  permissions_error,
  ios_simulator,
  back_without_scan,
  unknown
}

class KScanResult {
  String? data;
  KScanStatus status;

  KScanResult({this.data, this.status = KScanStatus.unknown});
}

abstract class KScanHelper {
  static Future<KScanResult> scan() async {
    Future<KScanResult> result =
        Future.value(KScanResult(status: KScanStatus.unknown));

    final permission = await Permission.camera.status;
    if (permission == PermissionStatus.granted) {
      result = _scan();
    } else if (permission == PermissionStatus.denied) {
      // Request permissions
      Map<Permission, PermissionStatus> permissionResult = await [
        Permission.camera,
      ].request();

      if (permissionResult[Permission.camera] == PermissionStatus.granted) {
        result = _scan();
      } else if (permissionResult[Permission.camera] ==
          PermissionStatus.denied) {
        result =
            Future.value(KScanResult(status: KScanStatus.permissions_error));
      }
    }
    return result;
  }

  /// PRIVATE
  static Future<KScanResult> _scan() async {
    final data = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      false,
      ScanMode.QR,
    );
    return KScanResult(
      data: data == "-1" ? null : data,
      status: data == "-1" ? KScanStatus.unknown : KScanStatus.ok,
    );
  }
}
