import 'dart:async';
import 'dart:ffi';

import 'package:app_core/model/chapter.dart';
import 'package:app_core/model/tbpage.dart';
import 'package:app_core/ui/widget/kimage_viewer.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

enum KDocViewMode { movable, fixed }

class KDocView extends StatefulWidget {
  final PageController controller;
  final Chapter chapter;
  final bool isDisableSwipe;

  KDocView({
    required this.controller,
    required this.chapter,
    this.isDisableSwipe = false,
  });

  @override
  _KDocViewState createState() => _KDocViewState();
}

class _KDocViewState extends State<KDocView> {
  int index = 0;

  TBPage? get currentPage =>
      widget.chapter.pages?[widget.controller.page?.toInt() ?? 0];

  @override
  void initState() {
    super.initState();
    precache();
  }

  void precache() async {
    // Priority first load
    await DefaultCacheManager()
        .downloadFile(widget.chapter.pages?.first.mediaURL ?? "");
    final pages = widget.chapter.pages ?? [];
    if (pages.length < 1) return;
    for (var i = 1; i < pages.length; i++) {
      DefaultCacheManager().downloadFile(pages[i].mediaURL ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = (widget.chapter.pages ?? []).map((page) {
      return _TextbookPageView(page);
    }).toList();
    return PageView(
      controller: widget.controller,
      physics: widget.isDisableSwipe ? NeverScrollableScrollPhysics() : null,
      children: pages,
    );
  }
}

class _TextbookPageView extends StatelessWidget {
  final TBPage page;

  const _TextbookPageView(this.page);

  @override
  Widget build(BuildContext context) {
    final body = GestureDetector(
      // onTap: () => Navigator.of(context).push(MaterialPageRoute(
      //     builder: (_) => KImageViewer.network(page.mediaURL ?? ""))),
      child: InteractiveViewer(
        panEnabled: false,
        minScale: 0.5,
        maxScale: 4,
        // boundaryMargin: EdgeInsets.all(40),
        child: Container(
          color: KStyles.darkGrey,
          child: CachedNetworkImage(
            imageUrl: page.mediaURL ?? "",
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );

    return body;
  }
}
