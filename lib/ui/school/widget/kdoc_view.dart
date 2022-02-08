import 'dart:ffi';

import 'package:app_core/model/chapter.dart';
import 'package:app_core/model/tbpage.dart';
import 'package:app_core/ui/widget/kimage_viewer.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final pages = (widget.chapter.pages ?? []).map((page) {
      return _TextbookPageView(page);
    }).toList();
    return PageView(
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
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => KImageViewer.network(page.mediaURL ?? ""))),
      child: InteractiveViewer(
        panEnabled: false,
        minScale: 0.5,
        maxScale: 4,
        // boundaryMargin: EdgeInsets.all(40),
        child: Container(
          color: KStyles.darkGrey,
          child: Image.network(
            page.mediaURL ?? "",
          ),
        ),
      ),
    );

    return body;
  }
}
