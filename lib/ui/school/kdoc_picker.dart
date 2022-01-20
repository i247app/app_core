import 'dart:async';

import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/helper/service/ktheme_service.dart';
import 'package:app_core/model/chapter.dart';
import 'package:app_core/model/textbook.dart';
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

  String? selectedGrade;
  bool isLoading = false;
  List<Chapter> chapters = [];
  List<Textbook> textbooks = [];
  List<String> grades = [];
  Widget? pickerView;
  @override
  void initState() {
    super.initState();

    loadTextBook(widget.type);
  }

  _onChangeHandler(String grade) {
    final chapters = textbooks.firstWhere((t) => t.grade == grade).chapters;
    setState(() {
      this.selectedGrade = grade;
      this.chapters = chapters ?? [];
    });
  }

  void loadTextBook(KDocType type) async {
    setState(() {
      this.isLoading = true;
    });
    final response = await KServerHandler.getListTextbook(type: type);

    if (response.isSuccess && response.textbooks != null) {
      final textbooks = response.textbooks!;
      final grades = textbooks.map((t) => t.grade ?? "").toList();

      final picker = Picker(
          adapter: PickerDataAdapter<String>(pickerdata: grades),
          hideHeader: true,
          itemExtent: 60,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selecteds: [this.grades.indexOf(selectedGrade ?? "")],
          height: 120,
          title: Text(KPhrases.grade),
          textStyle:
              Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 32),
          selectedTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.primary),
          onSelect: (Picker picker, int index, List<int> values) {
            final grade = picker.getSelectedValues()[0];
            _onChangeHandler(grade);
          });

      setState(() {
        this.textbooks.addAll(response.textbooks!);
        this.isLoading = false;
        this.grades.addAll(grades);
        this.pickerView = picker.makePicker();
      });

      _onChangeHandler(grades.first);
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: chapters.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              KPhrases.headstart,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(KPhrases.grade,
                                style: Theme.of(context).textTheme.headline6)
                          ],
                        ),
                      ),
                      Expanded(child: pickerView ?? Container()),
                    ],
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
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(
                  Icons.file_copy_outlined,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        chapter.title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle1!,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        chapter.subtitle ?? "",
                        style: Theme.of(context).textTheme.bodyText1,
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
