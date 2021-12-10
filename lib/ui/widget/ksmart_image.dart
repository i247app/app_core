import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:app_core/app_core.dart';
import 'package:app_core/header/kassets.dart';
import 'package:flutter/widgets.dart';

class KSmartImage extends StatefulWidget {
  final String? base64Data;
  final String? url;
  final Function()? onClick;

  const KSmartImage({this.base64Data, this.url, this.onClick});

  @override
  _KSmartImageState createState() => _KSmartImageState();
}

class _KSmartImageState extends State<KSmartImage> {
  static final Duration timeUntilDisplayLoadingBar =
      Duration(milliseconds: 1500);

  DateTime? timeStartedLoading;

  // Uint8List? preparedImageBytes;
  MemoryImage? preparedImage;
  String? errorMsg;

  bool get shouldDisplayLoadingBar =>
      timeStartedLoading
          ?.isBefore(DateTime.now().subtract(timeUntilDisplayLoadingBar)) ??
      false;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  void loadImage() async {
    setState(() {
      timeStartedLoading = DateTime.now();
      preparedImage = null;
      errorMsg = null;
    });

    // Trigger a setState to start displaying a loading bar if loading taking
    // a long time
    Timer(timeUntilDisplayLoadingBar, () => setState(() {}));

    if (widget.base64Data != null) {
      await loadMemoryImage();
    } else {
      await loadNetworkImage();
    }

    setState(() => timeStartedLoading = null);
  }

  Future loadMemoryImage() async {
    try {
      final bytes = base64Decode(widget.base64Data!);
      final image = MemoryImage(bytes);
      await precacheImage(image, context);
      setState(() => preparedImage = image);
    } catch (_) {
      setState(() => errorMsg = "Failed to decode image data");
    }
  }

  Future loadNetworkImage() async {
    try {
      final response = await get(Uri.parse(widget.url!));
      final image = MemoryImage(response.bodyBytes);
      await precacheImage(image, context);
      setState(() => preparedImage = image);
    } catch (_) {
      setState(() => errorMsg = "Failed to load image");
    }
  }

  Widget wrapWithStandardLook(
    Widget child, {
    required bool forceAspectRatio,
    bool forceOpacity = true,
  }) =>
      Container(
        color:
            Theme.of(context).primaryColor.withOpacity(forceOpacity ? 0.05 : 0),
        child: forceAspectRatio
            ? AspectRatio(aspectRatio: 1, child: child)
            : child,
      );

  @override
  Widget build(BuildContext context) {
    final errorView = InkWell(
      onTap: loadImage,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.refresh, size: 100),
          SizedBox(height: 10),
          Text(errorMsg ?? ""),
        ],
      ),
    );

    final loadedImageView = preparedImage == null
        ? Container()
        : InkWell(
            onTap: widget.onClick,
            borderRadius: BorderRadius.circular(14),
            child: FadeInImage(
              placeholder: AssetImage(KAssets.IMG_TRANSPARENCY),
              image: preparedImage!,
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 100),
              imageErrorBuilder: (_, __, ___) {
                errorMsg = "Tap to reload";
                return wrapWithStandardLook(
                  errorView,
                  forceAspectRatio: true,
                  forceOpacity: false,
                );
              },
            ),
          );

    final loadingView = Align(
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: shouldDisplayLoadingBar ? 1 : 0,
        child: LinearProgressIndicator(),
      ),
    );

    final content;
    final shouldForceAspectRatio;
    if (errorMsg == null && preparedImage != null) {
      content = loadedImageView;
      shouldForceAspectRatio = false;
    } else if (errorMsg != null) {
      content = errorView;
      shouldForceAspectRatio = true;
    } else {
      content = loadingView;
      shouldForceAspectRatio = true;
    }

    final body = AnimatedSize(
      duration: Duration(milliseconds: 100),
      child: wrapWithStandardLook(
        content,
        forceAspectRatio: shouldForceAspectRatio,
      ),
    );

    return body;
  }
}
