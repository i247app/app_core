import 'dart:async';

import 'package:app_core/helper/kmath_helper.dart';
import 'package:app_core/helper/kpush_data_helper.dart';
import 'package:app_core/helper/kscreen_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/chapter.dart';
import 'package:app_core/model/kpush_data.dart';
import 'package:app_core/ui/school/widget/kdoc_view.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KDocScreen extends StatefulWidget {
  final Chapter chapter;
  final KDocViewMode mode;
  final String? ssID;

  const KDocScreen({required this.chapter, required this.mode, this.ssID});

  @override
  State<StatefulWidget> createState() => _KDocScreenState();
}

class _KDocScreenState extends State<KDocScreen> {
  final PageController pageController = PageController();

  late final StreamSubscription streamSub;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    streamSub = KPushDataHelper.stream.listen(pushDataListener);
  }

  @override
  void dispose() {
    streamSub.cancel();
    KScreenHelper.resetOrientation(context);
    super.dispose();
  }

  void pushDataListener(KPushData pushData) {
    switch (pushData.app) {
      case "page.push":
        print("###### SETTING THE PAGE TO ${pushData.id} ######");
        final page = KMathHelper.parseInt(pushData.id);
        pageController.jumpToPage(page);
        break;
    }
  }

  void onPushClick() async {
    await KServerHandler.docPushPage(
      ssID: widget.ssID ?? "?",
      pageIndex: pageController.page.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chapterView = KDocView(
        chapter: widget.chapter,
        controller: pageController,
        isDisableSwipe: widget.mode == KDocViewMode.fixed);

    final pushButton = TextButton(
      onPressed: onPushClick,
      child: Text("Push"),
    );

    final topBar = Row(
      children: [
        BackButton(),
        Spacer(),
        if (widget.ssID != null) pushButton,
      ],
    );

    final body = Scaffold(
      backgroundColor: KStyles.darkGrey,
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
