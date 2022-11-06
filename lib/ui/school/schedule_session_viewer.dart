import 'dart:async';
import 'dart:math';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kmath_helper.dart';
import 'package:app_core/helper/kscreen_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/chapter.dart';
import 'package:app_core/model/kanswer.dart';
import 'package:app_core/model/kflash.dart';
import 'package:app_core/model/lop_schedule.dart';
import 'package:app_core/model/tbpage.dart';
import 'package:app_core/ui/school/widget/kdoc_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum ScheduleSessionMode { master, slave }

enum _PanelMode { chat, dashboard, quiz }

class _ScheduleKSessionData {
  final LopSchedule schedule;
  final int index;
  final ScheduleSessionMode mode;

  Chapter get chapter => schedule.textbooks!.first.chapters!.first;

  TBPage get page => chapter.pages![index];

  bool get isAtStart => (index + 0) <= 0;

  bool get isAtEnd => index >= (chapter.pages ?? []).length - 1;

  bool get showLeftArrow =>
      // mode == ScheduleSessionMode.master &&
      !isAtStart;

  bool get showRightArrow =>
      // mode == ScheduleSessionMode.master &&
      !isAtEnd;

  _ScheduleKSessionData({
    required this.schedule,
    required this.index,
    required this.mode,
  });
}

class ScheduleSessionViewer extends StatefulWidget {
  final LopSchedule schedule;

  ScheduleSessionMode get mode => (this
              .schedule
              .students
              ?.map((s) => s.puid)
              .contains(KSessionData.me!.puid) ??
          false)
      ? ScheduleSessionMode.slave
      : ScheduleSessionMode.master;

  const ScheduleSessionViewer(this.schedule);

  @override
  State<StatefulWidget> createState() => _ScheduleSessionViewerState();
}

class _ScheduleSessionViewerState extends State<ScheduleSessionViewer> {
  final List<List<String>> emojis = [
    // ["₿", KFlash.VALUE_BITCOIN],
    ["😊", KFlash.VALUE_SMILEY],
    ["😔", KFlash.VALUE_FROWN],
    ["⭐️", KFlash.VALUE_STAR],
    ["👍️", KFlash.VALUE_THUMB_UP],
    ["👎️", KFlash.VALUE_THUMB_DOWN],
    // ["📄", KFlash.VALUE_PAPER],
    // ["🍜", KFlash.VALUE_PHO],
  ];

  final pageCtrl = PageController();
  final panelCtrl = PanelController();
  late final chatroomCtrl = KChatroomController(
    refApp: "LOP_SCHEDULE",
    refID: widget.schedule.lopScheduleID,
  );

  late StreamSubscription streamSub;

  late _PanelMode panelMode = data.mode == ScheduleSessionMode.master
      ? _PanelMode.dashboard
      : _PanelMode.quiz; // _PanelMode.chat;

  _ScheduleKSessionData get data => _ScheduleKSessionData(
        schedule: widget.schedule,
        index: (pageCtrl.positions.isEmpty) ? 0 : pageCtrl.page?.toInt() ?? 0,
        mode: widget.mode,
      );

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    streamSub = KPushDataHelper.stream.listen(pushDataListen);
  }

  @override
  void dispose() {
    KScreenHelper.resetOrientation(context);
    streamSub.cancel();
    super.dispose();
  }

  void pushDataListen(KPushData pushData) {
    switch (pushData.app) {
      case "lop.page.push":
        print("###### SETTING THE PAGE TO ${pushData.id} ######");
        setPage(KMathHelper.parseInt(pushData.id));
        panelCtrl.close();

        print("INDEX # ${data.index}");
        debugPrint("PAGE ${KUtil.prettyJSON(data.page)}");
        break;
      case "lop.answer.prompt.notify":
        print("###### SHOW THE ANSWERS !!!! #####");
        panelCtrl.open();
        break;
      case "lop.flash.notify":
        print("###### FLASH ${pushData.id} #####");
        break;
    }
  }

  void setPage(int newIndex) async {
    if (newIndex < 0 || newIndex >= (data.chapter.pages ?? []).length) return;
    pageCtrl.jumpToPage(newIndex);
  }

  void movePage(int offset) async =>
      setPage(pageCtrl.page?.toInt() ?? 0 + offset);

  void onLessonChoiceClick(TBPage page, KAnswer choice) {
    final theCorrectAnswer = page.theQuestion!.correctAnswer!;
    if (theCorrectAnswer.text == choice.text) {
      KFlashHelper.rainConfetti();
    }
  }

  void onPushSlideClick() => KServerHandler.pushCurrentPage(
        pageIndex: data.index,
        scheduleID: data.schedule.lopScheduleID ?? "",
      );

  void onStartQuizClick() =>
      KServerHandler.startLopQuiz(data.schedule.lopScheduleID ?? "");

  void onPushEmojiClick(String emoji) => KServerHandler.pushFlashToLopSchedule(
        scheduleID: data.schedule.lopScheduleID ?? "",
        flashType: KFlash.TYPE_RAIN,
        mediaType: KFlash.MEDIA_EMOJI,
        flashValue: emoji,
      );

  void onPushHeroClick(String hero) => KServerHandler.pushFlashToLopSchedule(
        scheduleID: data.schedule.lopScheduleID ?? "",
        flashType: KFlash.TYPE_BANNER,
        mediaType: KFlash.MEDIA_HERO,
        flashValue: hero,
      );

  void selectTab(_PanelMode mode) => setState(() => panelMode = mode);

  @override
  Widget build(BuildContext context) {
    final lessonView = KDocView(
      controller: pageCtrl,
      chapter: data.chapter,
    );

    final chat = KChatroom(chatroomCtrl);

    final dashPageSelector = Row(
      children: [
        Visibility(
          visible: data.showLeftArrow,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: IconButton(
            onPressed: () => movePage(-1),
            icon: Icon(Icons.arrow_left, size: 40),
          ),
        ),
        Spacer(),
        Text(
          "${data.index + 1} / ${data.chapter.pages?.length ?? "?"}",
          style: KStyles.normalText,
        ),
        Spacer(),
        Visibility(
          visible: data.showRightArrow,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: IconButton(
            onPressed: () => movePage(1),
            icon: Icon(Icons.arrow_right, size: 40),
          ),
        ),
      ],
    );

    final dashPagePushButton = ElevatedButton(
      onPressed: onPushSlideClick,
      style: KStyles.squaredButton(
        KStyles.colorPrimary,
        textColor: KStyles.colorButtonText,
      ),
      child: Text("Push Slide"),
    );

    final dashQuizButton = ElevatedButton(
      onPressed: onStartQuizClick,
      style: KStyles.squaredButton(
        KStyles.colorSecondary,
        textColor: KStyles.colorButtonText,
      ),
      child: Text("Prompt KAnswer"),
    );

    final dashEmojiSender = Wrap(
      children: this
          .emojis
          .map((emoji) => TextButton(
                onPressed: () => onPushEmojiClick(emoji[1]),
                child: Text(emoji[0], style: KStyles.normalText),
              ))
          .toList(),
    );

    final dashHeroSender = ElevatedButton(
      onPressed: () => onPushHeroClick(
          Random().nextBool() ? KFlash.VALUE_DURIMAN : KFlash.VALUE_FUGU),
      style: KStyles.squaredButton(
        KStyles.colorSecondary,
        textColor: KStyles.colorButtonText,
      ),
      child: Text("Push a Hero"),
    );

    final controlDashboard = Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          dashPageSelector,
          SizedBox(height: 6),
          dashPagePushButton,
          if ((data.page.questions ?? []).isNotEmpty) ...[
            SizedBox(height: 6),
            dashQuizButton,
          ],
          SizedBox(height: 6),
          dashEmojiSender,
          dashHeroSender,
        ],
      ),
    );

    final answerSection = _AnswerSection(
      data,
      onChoiceClick: (z) => onLessonChoiceClick(data.page, z),
    );

    final panelContent;
    switch (panelMode) {
      case _PanelMode.chat:
        panelContent = chat;
        break;
      case _PanelMode.dashboard:
        panelContent = controlDashboard;
        break;
      case _PanelMode.quiz:
        panelContent = answerSection;
        break;
    }

    final panel = Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 80, height: 3, color: KStyles.lightGrey),
          SizedBox(height: 6),
          // tabBar,
          // SizedBox(height: 4),
          Expanded(child: panelContent),
        ],
      ),
    );

    final background = Column(
      children: [
        Expanded(child: lessonView),
        if (data.mode == ScheduleSessionMode.master) SizedBox(height: 100),
      ],
    );

    final content = SlidingUpPanel(
      controller: panelCtrl,
      minHeight: data.mode == ScheduleSessionMode.master ? 130 : 0,
      maxHeight: 240,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      isDraggable: true,
      body: background,
      panel: panel,
    );

    final header = Row(
      children: [
        BackButton(color: Colors.white),
        SizedBox(width: 10),
        Text(
          widget.schedule.title ?? "Lesson",
          style: KStyles.largeXLText.copyWith(color: Colors.white),
        ),
      ],
    );

    final body = Stack(
      fit: StackFit.expand,
      children: [
        content,
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(child: header),
        ),
      ],
    );

    return Scaffold(body: body);
  }
}

class _AnswerSection extends StatefulWidget {
  final _ScheduleKSessionData data;
  final Function(KAnswer) onChoiceClick;

  const _AnswerSection(this.data, {required this.onChoiceClick});

  @override
  _AnswerSectionState createState() => _AnswerSectionState();
}

class _AnswerSectionState extends State<_AnswerSection> {
  final Set<KAnswer> attempts = {};

  List<KAnswer> get theChoices => widget.data.page.theQuestion?.answers ?? [];

  @override
  void didUpdateWidget(covariant _AnswerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.page.pageID != widget.data.page.pageID)
      setState(() => attempts.clear());
  }

  void onAttemptAnswer(KAnswer a) {
    setState(() => attempts.add(a));
    widget.onChoiceClick(a);
  }

  @override
  Widget build(BuildContext context) {
    final choices = Wrap(
      spacing: 10,
      children: this
          .theChoices
          .map(
            (c) => _AnswerButton(
              c,
              onClick: onAttemptAnswer,
              attempts: attempts..remove(widget.data.page.title),
            ),
          )
          .toList(),
    );

    final body = choices;

    return body;
  }
}

class _AnswerButton extends StatelessWidget {
  final KAnswer answer;
  final Function(KAnswer) onClick;
  final Set<KAnswer> attempts;

  bool get isWrong =>
      !(answer.isCorrect ?? false) &&
      attempts.map((a) => a.text).contains(answer.text);

  bool get isCorrect =>
      (answer.isCorrect ?? false) &&
      attempts.map((a) => a.text).contains(answer.text);

  const _AnswerButton(
    this.answer, {
    required this.onClick,
    required this.attempts,
  });

  @override
  Widget build(BuildContext context) {
    final body = Text(
      answer.text ?? "## missing ##",
      style: TextStyle(
        color: (isWrong || isCorrect) ? Colors.white : Colors.black,
      ),
    );

    return Container(
      width: 140,
      child: ElevatedButton(
        onPressed: () => onClick(answer),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(6),
          primary: isCorrect
              ? KStyles.colorSuccess
              : isWrong
                  ? KStyles.colorError
                  : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: KStyles.grey),
          ),
        ),
        child: body,
      ),
    );
  }
}
