import 'package:app_core/model/chapter.dart';
import 'package:app_core/ui/school/widget/kchapter_view.dart';
import 'package:flutter/material.dart';

class KChapterScreen extends StatelessWidget {
  final Chapter chapter;
  final KChapterViewMode mode;
  final Function(Chapter)? onPush;

  const KChapterScreen({
    Key? key,
    required this.chapter,
    required this.mode,
    this.onPush,
  }) : super(key: key);

  void onPushClick() => onPush?.call(chapter);

  @override
  Widget build(BuildContext context) {
    final chapterView = KChapterView(chapter: chapter);

    final pushButton = TextButton(
      onPressed: onPushClick,
      child: Text("Push"),
    );

    final topBar = Row(
      children: [
        BackButton(),
        Spacer(),
        if (onPush != null) pushButton,
      ],
    );

    final body = Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          chapterView,
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(child: topBar),
          ),
        ],
      ),
    );

    return body;
  }
}
