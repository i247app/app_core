import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/value/styles.dart';

enum _ImageViewerType { url, file }

class ImageViewer extends StatefulWidget {
  final String? imageURL;
  final File? imageFile;

  const ImageViewer({
    this.imageURL,
    this.imageFile,
  });

  @override
  State<StatefulWidget> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
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

  // void onSaveClick() async {
  //   if (widget.imageURL != null) {
  //     final isSuccess = await FileHelper.downloadImageFromURL(widget.imageURL!);
  //     if (isSuccess)
  //       ToastHelper.success("Image saved!");
  //     else
  //       ToastHelper.error("Failed to save image.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: CircleAvatar(
          backgroundColor: Styles.extraDarkGrey,
          child: Icon(
            Icons.close,
            color: Styles.colorButtonText,
          )),
    );

    // final saveButton = IconButton(
    //   onPressed: onSaveClick,
    //   icon: CircleAvatar(
    //     backgroundColor: Styles.extraDarkGrey,
    //     child: Icon(Icons.save, color: Styles.colorButtonText),
    //   ),
    // );

    final topBar = Row(
      children: [
        backButton,
        Spacer(),
        // if (this.imageType == _ImageViewerType.url) saveButton,
      ],
    );

    final rawImage = this.imageProvider == null
        ? Container()
        : Image(
            image: this.imageProvider!,
            fit: BoxFit.contain,
          );

    final imageViewer = Container(
      color: Styles.black,
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
