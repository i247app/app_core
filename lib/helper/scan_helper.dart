import 'dart:async';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

enum AppCoreScanStatus {
  ok,
  permissions_error,
  ios_simulator,
  back_without_scan,
  unknown
}

class AppCoreScanResult {
  String? data;
  AppCoreScanStatus status;

  AppCoreScanResult({this.data, this.status = AppCoreScanStatus.unknown});
}

abstract class AppCoreScanHelper {
  static Future<AppCoreScanResult> scan() async {
    Future<AppCoreScanResult> result =
        Future.value(AppCoreScanResult(status: AppCoreScanStatus.unknown));

    PermissionStatus permission = await Permission.camera.status;

    if (permission == PermissionStatus.granted) {
      result = _scan();
    } else if (permission == PermissionStatus.denied) {
      // Request permissions
      Map<Permission, PermissionStatus> permissionResult = await [
        Permission.camera,
      ].request();

      if (permissionResult[Permission.camera] == PermissionStatus.granted)
        result = _scan();
      else if (permissionResult[Permission.camera] ==
          PermissionStatus.denied)
        result = Future.value(AppCoreScanResult(status: AppCoreScanStatus.permissions_error));
    }
    return result;
  }

  static Future<AppCoreScanResult> _scan() async {
    final data = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.QR);
    return AppCoreScanResult(
        data: data == "-1" ? null : data,
        status: data == "-1" ? AppCoreScanStatus.unknown : AppCoreScanStatus.ok);
  }
}
