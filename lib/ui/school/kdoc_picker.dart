import 'dart:async';

import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/chapter.dart';
import 'package:app_core/ui/school/widget/kchapter_view.dart';
import 'package:app_core/value/kphrases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

enum KDocType { headstart, classes }

class KDocPicker extends StatefulWidget {
  final KDocType type;

  const KDocPicker({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  _KDocPickerState createState() => _KDocPickerState();
}

class _KDocPickerState extends State<KDocPicker> {
  Timer? searchOnStoppedTyping;

  late Picker picker;
  int grade = 0;
  bool isLoading = false;
  List<Chapter> chapters = [];

  @override
  void initState() {
    super.initState();
    this.picker = Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
            begin: 0,
            end: 12,
          ),
        ]),
        hideHeader: true,
        selecteds: [0],
        height: 60,
        title: Text(KPhrases.grade),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onSelect: (Picker picker, int index, List<int> values) {
          final grade = picker.getSelectedValues()[0];
          setState(() {
            this.grade = grade;
          });

          _onChangeHandler(grade);
        });
    loadTextBook(widget.type, grade);
  }

  _onChangeHandler(int value) {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping?.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping =
        new Timer(duration, () => loadTextBook(widget.type, value)));
  }

  void loadTextBook(KDocType type, int grade) async {
    setState(() {
      this.isLoading = true;
    });
    final response =
        await KServerHandler.getListTextbook(type: type, grade: grade);

    if (response.isSuccess) {
      final textbook = response.textbooks?.first;
      final grade = picker.getSelectedValues()[0];
      if (textbook?.grade != grade.toString()) {
        setState(() {
          this.chapters = [];
          this.isLoading = false;
        });
        return;
      }
      final chapters = textbook!.chapters;

      setState(() {
        this.chapters = chapters ?? [];
        this.isLoading = false;
      });
    } else {
      setState(() {
        this.chapters = [];
        isLoading = false;
      });
    }
  }

  void onChapterClick(Chapter selectedChapter) async {
    final response = await KServerHandler.getTextbook(
      textbookID: selectedChapter.textbookID!,
      chapterID: selectedChapter.chapterID!,
    );

    if (response.isSuccess && (response.textbooks ?? []).isNotEmpty) {
      final fullChapter = response.textbooks!.first.chapters!
          .firstWhere((c) => selectedChapter.chapterID == c.chapterID);
      Navigator.of(context).pop(fullChapter);
      return;

      final screen = Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            KChapterView(chapter: fullChapter),
            Align(
              alignment: Alignment.topLeft,
              child: SafeArea(child: BackButton()),
            ),
          ],
        ),
      );
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == KDocType.headstart
            ? KPhrases.headstartDoc
            : KPhrases.classDoc),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: isLoading ? 2 : chapters.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(KPhrases.headstartGrade),
                Expanded(child: picker.makePicker())
              ],
            );
          }
          if (index == 1 && isLoading) {
            return Container(
              height: 400,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final chapter = chapters[index - 1];
          return _ChapterItem(
            chapter: chapter,
            onTap: onChapterClick,
          );
        },
      ),
    );
  }
}

class _ChapterItem extends StatelessWidget {
  final Chapter chapter;
  final Function(Chapter) onTap;

  const _ChapterItem({
    Key? key,
    required this.onTap,
    required this.chapter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(chapter),
      child: Card(
        child: Container(
          height: 100,
          child: Row(
            children: [
              Icon(
                Icons.file_copy_outlined,
                size: 90,
                color: Theme.of(context).colorScheme.primary,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        chapter.title ?? "",
                        style: Theme.of(context).textTheme.subtitle1!,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        chapter.subtitle ?? "",
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
