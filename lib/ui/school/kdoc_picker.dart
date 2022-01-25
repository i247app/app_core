import 'dart:async';

import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/helper/service/ktheme_service.dart';
import 'package:app_core/model/chapter.dart';
import 'package:app_core/model/textbook.dart';
import 'package:app_core/value/kphrases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

enum KDocType { headstart, classes }

class KDocPicker extends StatefulWidget {
  final KDocType type;
  final String? subject;
  final String? grade;

  const KDocPicker({
    Key? key,
    required this.type,
    this.subject,
    this.grade,
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
      dynamic subjects = [
        {KPhrases.math: grades},
        {KPhrases.english: grades},
      ];

      var selected = [0, 0];
      if (widget.subject != null) {
        selected = [
          subjects.indexWhere((s) => s.keys.first == widget.subject),
          grades.indexWhere((g) => g == widget.grade),
        ];
      }

      final picker = Picker(
          adapter: PickerDataAdapter<String>(pickerdata: subjects),
          hideHeader: true,
          itemExtent: 60,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selecteds: selected,
          height: 120,
          title: Text(KPhrases.grade),
          textStyle:
              Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 32),
          selectedTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.primary),
          onSelect: (Picker picker, int index, List<int> values) {
            final grade = picker.getSelectedValues()[1];
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (pickerView != null) pickerView!,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Divider(
                            color: Theme.of(context).colorScheme.primary),
                      )
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () => onTap.call(chapter),
        child: Card(
          elevation: KThemeService.isDarkMode() ? 0 : 1,
          child: Container(
            decoration: BoxDecoration(
              color: KThemeService.isDarkMode()
                  ? Colors.grey.shade900.withOpacity(0.4)
                  : Colors.transparent,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Icon(
                    Icons.menu_book,
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
      ),
    );
  }
}
