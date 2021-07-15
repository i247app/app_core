import 'dart:io';

import 'package:app_core/ui/widget/choose_photo_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum AppCorePhotoStatus { ok, permission_error, unknown }

class AppCorePhotoResult {
  File? photoFile;
  AppCorePhotoStatus status;

  AppCorePhotoResult({this.photoFile, required this.status});
}

abstract class AppCorePhotoHelper {
  static Future<AppCorePhotoResult> chooser(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (ctx) => ChoosePhotoBottomSheetView(),
    );

    return result ?? AppCorePhotoResult(status: AppCorePhotoStatus.unknown);
  }

  static Future<AppCorePhotoResult> camera() async => _do(ImageSource.camera);

  static Future<AppCorePhotoResult> gallery() async => _do(ImageSource.gallery);

  static Future<AppCorePhotoResult> _do(ImageSource source) async {
    // TODO might need to uncomment the below lines
    // final permissionStatus = await Permission.storage.request();
    // if (permissionStatus != PermissionStatus.granted) return null;

    AppCorePhotoResult? result;
    try {
      //##### PickedFile
      final _picker = ImagePicker();
      PickedFile? pickedFile = await _picker.getImage(source: source);

      if (pickedFile != null)
        result = AppCorePhotoResult(
          photoFile: File(pickedFile.path),
          status: AppCorePhotoStatus.ok,
        );
    } on PlatformException catch (e) {
      if (["photo_access_denied", "camera_access_denied"].contains(e.code))
        result = AppCorePhotoResult(status: AppCorePhotoStatus.permission_error);
    }
    result ??= AppCorePhotoResult(status: AppCorePhotoStatus.unknown);

    return Future.value(result);
  }
}
