import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
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
    final data = await BarcodeScanner.scan(
      options: ScanOptions(
        strings: {
          'cancel': 'Cancel',
        },
        restrictFormat: [BarcodeFormat.qr],
        autoEnableFlash: false,
      ),
    );
    return KScanResult(
      data: data.rawContent == "-1" ? null : data.rawContent,
      status: data.rawContent == "-1" ? KScanStatus.unknown : KScanStatus.ok,
    );
  }
}
