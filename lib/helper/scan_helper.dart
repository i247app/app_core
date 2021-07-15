import 'dart:async';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

enum ScanStatus {
  ok,
  permissions_error,
  ios_simulator,
  back_without_scan,
  unknown
}

class ScanResult {
  String? data;
  ScanStatus status;

  ScanResult({this.data, this.status = ScanStatus.unknown});
}

abstract class ScanHelper {
  static Future<ScanResult> scan() async {
    Future<ScanResult> result =
        Future.value(ScanResult(status: ScanStatus.unknown));

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
        result = Future.value(ScanResult(status: ScanStatus.permissions_error));
    }
    return result;
  }

  static Future<ScanResult> _scan() async {
    final data = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.QR);
    return ScanResult(
        data: data == "-1" ? null : data,
        status: data == "-1" ? ScanStatus.unknown : ScanStatus.ok);
  }
}
