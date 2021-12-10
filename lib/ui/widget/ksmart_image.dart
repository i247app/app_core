import 'dart:convert';

import 'package:app_core/app_core.dart';
import 'package:app_core/header/kassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KSmartImage extends StatefulWidget {
  final String? base64Data;
  final String? url;
  final Function()? onClick;

  const KSmartImage({
    this.base64Data,
    this.url,
    this.onClick,
  });

  @override
  _KSmartImageState createState() => _KSmartImageState();
}

class _KSmartImageState extends State<KSmartImage> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  Widget wrapWithStandardLook(
    Widget child, {
    required bool forceAspectRatio,
    bool forceOpacity = true,
  }) =>
      Container(
        color: Theme.of(context)
            .scaffoldBackgroundColor
            .withOpacity(forceOpacity ? 0.05 : 0),
        child: forceAspectRatio
            ? AspectRatio(aspectRatio: 1, child: child)
            : child,
      );

  @override
  Widget build(BuildContext context) {
    final rawImage = (widget.url != null
        ? NetworkImage(widget.url ?? "")
        : MemoryImage(base64Decode(widget.base64Data ?? ""))) as ImageProvider;

    final loadedImageView = InkWell(
      onTap: widget.onClick,
      borderRadius: BorderRadius.circular(14),
      child: FadeInImage(
        placeholder: AssetImage(KAssets.IMG_TRANSPARENCY),
        image: rawImage,
        fit: BoxFit.contain,
        fadeInDuration: Duration(milliseconds: 100),
      ),
    );

    final content = loadedImageView;
    final shouldForceAspectRatio = false;

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
