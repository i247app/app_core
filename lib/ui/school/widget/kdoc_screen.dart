import 'dart:async';

import 'package:app_core/helper/kmath_helper.dart';
import 'package:app_core/helper/kpush_data_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/chapter.dart';
import 'package:app_core/model/kpush_data.dart';
import 'package:app_core/ui/school/widget/kdoc_view.dart';
import 'package:flutter/material.dart';

class KDocScreen extends StatefulWidget {
  final Chapter chapter;
  final KDocViewMode mode;
  final String? ssID;

  const KDocScreen({required this.chapter, required this.mode, this.ssID});

  @override
  State<StatefulWidget> createState() => _KDocScreenState();
}

class _KDocScreenState extends State<KDocScreen> {
  final ValueNotifier<int> pageCtrl = ValueNotifier(0);

  late final StreamSubscription streamSub;

  @override
  void initState() {
    super.initState();
    streamSub = KPushDataHelper.stream.listen(pushDataListener);
  }

  @override
  void dispose() {
    streamSub.cancel();
    super.dispose();
  }

  void pushDataListener(KPushData pushData) {
    switch (pushData.app) {
      case "page.push":
        print("###### SETTING THE PAGE TO ${pushData.id} ######");
        pageCtrl.value = KMathHelper.parseInt(pushData.id);
        break;
    }
  }

  void onPushClick() async {
    final response = await KServerHandler.docPushPage(
      ssID: widget.ssID ?? "?",
      pageIndex: pageCtrl.value.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chapterView = KDocView(chapter: widget.chapter, controller: pageCtrl);

    final pushButton = TextButton(
      onPressed: onPushClick,
      child: Text("Push"),
    );

    final topBar = Row(
      children: [
        BackButton(),
        Spacer(),
        pushButton,
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
