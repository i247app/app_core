import 'package:app_core/helper/kphoto_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KChoosePhotoBottomSheetView extends StatefulWidget {
  final bool hero;
  const KChoosePhotoBottomSheetView({required this.hero});
  @override
  _KChoosePhotoBottomSheetViewState createState() =>
      _KChoosePhotoBottomSheetViewState();
}

class _KChoosePhotoBottomSheetViewState
    extends State<KChoosePhotoBottomSheetView> {
  void onCameraClick() async {
    final result = await KPhotoHelper.camera();
    Navigator.of(context).pop(result);
  }

  void onGalleryClick() async {
    final result = await KPhotoHelper.gallery();
    Navigator.of(context).pop(result);
  }

  void onHeroClicked() async {
    final result = KPhotoResult(status: KPhotoStatus.hero);
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final edgeInsets = EdgeInsets.symmetric(horizontal: 10, vertical: 16);

    final body = SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onCameraClick,
            child: Container(
              padding: edgeInsets,
              child: Row(
                children: [
                  Icon(Icons.camera),
                  SizedBox(width: 10),
                  Text("Take a Photo"),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: onGalleryClick,
            child: Container(
              padding: edgeInsets,
              child: Row(
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: 10),
                  Text("Choose from Gallery"),
                ],
              ),
            ),
          ),
          if (widget.hero) ...[
            InkWell(
              onTap: onHeroClicked,
              child: Container(
                padding: edgeInsets,
                child: Row(
                  children: [
                    Icon(Icons.health_and_safety),
                    SizedBox(width: 10),
                    Text("Hero Avatar"),
                  ],
                ),
              ),
            )
          ],
        ],
      ),
    );

    return body;
  }
}
