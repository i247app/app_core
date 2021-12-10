import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:app_core/app_core.dart';
import 'package:app_core/header/kassets.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery_saver/files.dart';

class KSmartImage extends StatefulWidget {
  final String? base64Data;
  final String? url;

  const KSmartImage({this.base64Data, this.url});

  @override
  _KSmartImageState createState() => _KSmartImageState();
}

class _KSmartImageState extends State<KSmartImage> {
  Uint8List? preparedImageBytes;
  String? errorMsg;

  @override
  void initState() {
    super.initState();

    if (widget.base64Data != null) {
      loadMemoryImage();
    } else {
      loadNetworkImage();
    }
  }

  void loadMemoryImage() async {
    try {
      final bytes = base64Decode(widget.base64Data!);
      setState(() => preparedImageBytes = bytes);
    } catch (_) {
      setState(() => errorMsg = "Failed to decode image data");
    }
  }

  void loadNetworkImage() async {
    try {
      final response = await get(Uri.parse(widget.url!));
      final bytes = response.bodyBytes;
      setState(() => preparedImageBytes = bytes);
    } catch (_) {
      setState(() => errorMsg = "Failed to load image");
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadedImageView = preparedImageBytes == null
        ? Container()
        : FadeInImage(
            placeholder: AssetImage(KAssets.IMG_TRANSPARENCY),
            image: MemoryImage(preparedImageBytes!),
            fit: BoxFit.contain,
            fadeInDuration: Duration(milliseconds: 100),
          );

    final errorView = AspectRatio(
      aspectRatio: 1,
      child: Center(child: Text(errorMsg ?? "")),
    );

    final body = AnimatedSize(
      duration: Duration(milliseconds: 100),
      child: errorMsg == null ? loadedImageView : errorView,
    );

    return body;
  }
}
