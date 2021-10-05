import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/kfile_helper.dart';
import 'package:app_core/helper/ktoast_helper.dart';
import 'package:app_core/header/kstyles.dart';

enum _ImageViewerType { url, file }

class KImageViewer extends StatefulWidget {
  final String? imageURL;
  final File? imageFile;

  const KImageViewer({
    this.imageURL,
    this.imageFile,
  });

  @override
  State<StatefulWidget> createState() => _KImageViewerState();
}

class _KImageViewerState extends State<KImageViewer> {
  ImageProvider? imageProvider;

  _ImageViewerType get imageType {
    if (widget.imageURL != null)
      return _ImageViewerType.url;
    else if (widget.imageFile != null)
      return _ImageViewerType.file;
    else
      return _ImageViewerType.file;
  }

  @override
  void initState() {
    super.initState();

    switch (this.imageType) {
      case _ImageViewerType.url:
        this.imageProvider = NetworkImage(widget.imageURL!);
        break;
      case _ImageViewerType.file:
        this.imageProvider = FileImage(widget.imageFile!);
        break;
    }
  }

  void onSaveClick() async {
    if (widget.imageURL != null) {
      final isSuccess =
          await KFileHelper.downloadImageFromURL(widget.imageURL!);
      if (isSuccess)
        KToastHelper.success("Image saved!");
      else
        KToastHelper.error("Failed to save image.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: CircleAvatar(
          backgroundColor: KStyles.extraDarkGrey,
          child: Icon(
            Icons.close,
            color: KStyles.colorButtonText,
          )),
    );

    final saveButton = IconButton(
      onPressed: onSaveClick,
      icon: CircleAvatar(
        backgroundColor: KStyles.extraDarkGrey,
        child: Icon(Icons.save, color: KStyles.colorButtonText),
      ),
    );

    final topBar = Row(
      children: [
        backButton,
        Spacer(),
        if (this.imageType == _ImageViewerType.url) saveButton,
      ],
    );

    final rawImage = this.imageProvider == null
        ? Container()
        : Image(
            image: this.imageProvider!,
            fit: BoxFit.contain,
          );

    final imageViewer = Container(
      color: KStyles.black,
      child: InteractiveViewer(
        panEnabled: false,
        minScale: 0.5,
        maxScale: 2,
        // boundaryMargin: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Expanded(child: rawImage)],
        ),
      ),
    );

    final body = Stack(
      fit: StackFit.expand,
      children: [
        Center(child: imageViewer),
        Align(
          alignment: Alignment.topLeft,
          child: SafeArea(child: topBar),
        ),
      ],
    );

    return body;
  }
}
