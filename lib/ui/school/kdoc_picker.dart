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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selecteds: [this.grades.indexOf(selectedGrade ?? "")],
          height: 60,
          title: Text(KPhrases.grade),
          textStyle:
              TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          selectedTextStyle: TextStyle(color: Colors.blue),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: isLoading ? 2 : chapters.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [Text(KPhrases.headstart), Text(KPhrases.grade)],
                ),
                Expanded(child: pickerView ?? Container()),
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
