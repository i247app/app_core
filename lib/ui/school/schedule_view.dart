import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/lop_schedule.dart';
import 'package:app_core/ui/school/schedule_session_view.dart';
import 'package:app_core/value/kphrases.dart';
import 'package:flutter/material.dart';

class ScheduleView extends StatefulWidget {
  final LopSchedule schedule;

  const ScheduleView(this.schedule);

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late LopSchedule theSchedule;

  bool isLoading = false;

  bool get isTextbookAvailable => (theSchedule.textbooks ?? []).isNotEmpty;

  bool get isInstructor => (theSchedule.instructors ?? [])
      .map((i) => i.puid)
      .contains(KSessionData.me!.puid ?? "@@@");

  @override
  void initState() {
    super.initState();
    theSchedule = widget.schedule;
    getSchedule();
  }

  void getSchedule() async {
    setState(() {
      isLoading = true;
    });

    final response = await KServerHandler.getLopSchedule(
      lopID: theSchedule.lopID ?? "",
      scheduleID: theSchedule.lopScheduleID ?? "",
    );

    setState(() {
      isLoading = false;
    });

    if (response.isSuccess && (response.schedules ?? []).isNotEmpty) {
      setState(() {
        theSchedule = response.schedules!.first;
      });
    }
  }

  void onViewSessionClick() => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ScheduleSessionView(theSchedule)));

  void onEditExternalLinkClick() async {
    final response = await showDialog(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: Text("Edit Link"),
          content: TextField(
            controller: ctrl,
            minLines: 3,
            maxLines: 5,
            textInputAction: TextInputAction.newline,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(KPhrases.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(ctrl.text),
              child: Text(KPhrases.ok),
            ),
          ],
        );
      },
    );

    if (response != null) {
      modifyExternalLink(response);
    }
  }

  Future modifyExternalLink(String externalLink) async {
    setState(() {
      isLoading = true;
    });

    final response = await KServerHandler.modifyLopSchedule(theSchedule
      ..action = "modify"
      ..externalLink = externalLink);
    if (response.isSuccess && (response.schedules ?? []).isNotEmpty) {
      setState(() {
        theSchedule = response.schedules!.first;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lopInfo = Card(
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  theSchedule.title ?? "",
                  style: KStyles.normalText.copyWith(color: KStyles.black),
                ),
                SizedBox(height: 2),
                Text(
                  theSchedule.text ?? "",
                  style: KStyles.detailText.copyWith(color: KStyles.darkGrey),
                ),
                SizedBox(height: 10),
                Text(
                  "Instructor: ${theSchedule.theInstructor.fullName}",
                  style: KStyles.detailText.copyWith(color: KStyles.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    final externalLink = Card(
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Video Link",
                  style: KStyles.normalText.copyWith(color: KStyles.black),
                ),
                Spacer(),
                if (isInstructor)
                  isLoading
                      ? CircularProgressIndicator()
                      : IconButton(
                          onPressed: onEditExternalLinkClick,
                          icon: Icon(Icons.edit),
                        ),
              ],
            ),
            SizedBox(height: 2),
            Text(
              theSchedule.externalLink ?? "",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );

    final viewTextbookBtn = ElevatedButton(
      onPressed: onViewSessionClick,
      child: Text("View Textbook"),
      style: KStyles.roundedButton(Theme.of(context).colorScheme.primary),
    );

    final buttons = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isTextbookAvailable) viewTextbookBtn,
      ],
    );

    final body = Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          lopInfo,
          SizedBox(height: 8),
          externalLink,
          SizedBox(height: 10),
          buttons,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(theSchedule.title ?? "")),
      body: body,
    );
  }
}
