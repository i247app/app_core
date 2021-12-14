import 'package:app_core/helper/kphoto_helper.dart';
import 'package:flutter/material.dart';

class KChoosePhotoBottomSheetView extends StatefulWidget {
  final bool hero;
  final bool showRemoveHero;
  const KChoosePhotoBottomSheetView(
      {required this.hero, required this.showRemoveHero});
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

  void onRemoveHeroClicked() async {
    final result = KPhotoResult(status: KPhotoStatus.removeHero);
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
                  Icon(Icons.photo_camera),
                  SizedBox(width: 10),
                  Text("Camera"),
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
                  Text("Photo"),
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
                    Icon(Icons.pets_outlined),
                    SizedBox(width: 10),
                    Text("Hero Avatar"),
                  ],
                ),
              ),
            )
          ],
          if (widget.showRemoveHero) ...[
            InkWell(
              onTap: onRemoveHeroClicked,
              child: Container(
                padding: edgeInsets,
                child: Row(
                  children: [
                    Icon(Icons.not_interested_outlined),
                    SizedBox(width: 10),
                    Text("Remove Hero Avatar"),
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
