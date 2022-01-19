import 'dart:math';

import 'package:app_core/header/kassets.dart';
import 'package:app_core/model/chapter.dart';
import 'package:app_core/model/tbpage.dart';
import 'package:app_core/ui/widget/kimage_viewer.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';

class KChapterView extends StatefulWidget {
  final ValueNotifier<int>? controller;
  final Chapter chapter;

  KChapterView({this.controller, required this.chapter});

  @override
  _KChapterViewState createState() => _KChapterViewState();
}

class _KChapterViewState extends State<KChapterView> {
  int index = 0;

  TBPage? get currentPage => widget.chapter.pages?[index];

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(controllerListener);
  }

  void controllerListener() {
    if (widget.controller != null) {
      setState(() {
        index = widget.controller!.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = currentPage == null
        ? Container()
        : GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    KImageViewer.network(currentPage?.mediaURL ?? ""))),
            child: _TextbookPageView(currentPage!),
          );
    // return Image.network(currentPage?.mediaURL ?? "");
    final body = Stack(
      fit: StackFit.expand,
      children: [
        content,
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => setState(() => index = max(0, index - 1)),
            child: Container(
              height: 100,
              width: 40,
              color: Colors.grey.withOpacity(0.3),
              child: Icon(Icons.arrow_left, size: 30),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () => setState(() => index =
                min((widget.chapter.pages ?? []).length - 1, index + 1)),
            child: Container(
              height: 100,
              width: 40,
              color: Colors.grey.withOpacity(0.3),
              child: Icon(Icons.arrow_right, size: 30),
            ),
          ),
        ),
      ],
    );

    return body;
  }
}

class _TextbookPageView extends StatelessWidget {
  final TBPage page;

  const _TextbookPageView(this.page);

  @override
  Widget build(BuildContext context) {
    final body = InteractiveViewer(
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
    );

    return body;
  }
}
