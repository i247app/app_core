import 'dart:io';

import 'package:app_core/ui/widget/kchoose_photo_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum KPhotoStatus { ok, permission_error, unknown, hero }

class KPhotoResult {
  File? photoFile;
  KPhotoStatus status;

  KPhotoResult({this.photoFile, required this.status});
}

abstract class KPhotoHelper {
  static Future<KPhotoResult> chooser(BuildContext context,
      {bool hero = false}) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (ctx) => KChoosePhotoBottomSheetView(hero: hero),
    );

    return result ?? KPhotoResult(status: KPhotoStatus.unknown);
  }

  static Future<KPhotoResult> camera() async => _do(ImageSource.camera);

  static Future<KPhotoResult> gallery() async => _do(ImageSource.gallery);

  static Future<KPhotoResult> _do(ImageSource source) async {
    // TODO might need to uncomment the below lines
    // final permissionStatus = await Permission.storage.request();
    // if (permissionStatus != PermissionStatus.granted) return null;

    KPhotoResult? result;
    try {
      //##### PickedFile
      final _picker = ImagePicker();
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null)
        result = KPhotoResult(
          photoFile: File(pickedFile.path),
          status: KPhotoStatus.ok,
        );
    } on PlatformException catch (e) {
      if (["photo_access_denied", "camera_access_denied"].contains(e.code))
        result = KPhotoResult(status: KPhotoStatus.permission_error);
    }
    result ??= KPhotoResult(status: KPhotoStatus.unknown);

    return Future.value(result);
  }
}
