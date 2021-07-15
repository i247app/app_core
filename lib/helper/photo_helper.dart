import 'dart:io';

import 'package:app_core/ui/widget/choose_photo_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum PhotoStatus { ok, permission_error, unknown }

class PhotoResult {
  File? photoFile;
  PhotoStatus status;

  PhotoResult({this.photoFile, required this.status});
}

abstract class PhotoHelper {
  static Future<PhotoResult> chooser(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (ctx) => ChoosePhotoBottomSheetView(),
    );

    return result ?? PhotoResult(status: PhotoStatus.unknown);
  }

  static Future<PhotoResult> camera() async => _do(ImageSource.camera);

  static Future<PhotoResult> gallery() async => _do(ImageSource.gallery);

  static Future<PhotoResult> _do(ImageSource source) async {
    // TODO might need to uncomment the below lines
    // final permissionStatus = await Permission.storage.request();
    // if (permissionStatus != PermissionStatus.granted) return null;

    PhotoResult? result;
    try {
      //##### PickedFile
      final _picker = ImagePicker();
      PickedFile? pickedFile = await _picker.getImage(source: source);

      if (pickedFile != null)
        result = PhotoResult(
          photoFile: File(pickedFile.path),
          status: PhotoStatus.ok,
        );
    } on PlatformException catch (e) {
      if (["photo_access_denied", "camera_access_denied"].contains(e.code))
        result = PhotoResult(status: PhotoStatus.permission_error);
    }
    result ??= PhotoResult(status: PhotoStatus.unknown);

    return Future.value(result);
  }
}
