import 'package:app_core/app_core.dart';
import 'package:app_core/model/lop_schedule.dart';
import 'package:app_core/ui/school/schedule_session_view.dart';
import 'package:flutter/material.dart';

class ScheduleView extends StatefulWidget {
  final LopSchedule schedule;

  const ScheduleView(this.schedule);

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  void onViewSessionClick() => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ScheduleSessionView(widget.schedule)));

  @override
  Widget build(BuildContext context) {
    final info = Card(
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.schedule.title ?? "",
                  style: KStyles.normalText.copyWith(color: KStyles.black),
                ),
                SizedBox(height: 2),
                Text(
                  widget.schedule.text ?? "",
                  style: KStyles.detailText.copyWith(color: KStyles.darkGrey),
                ),
              ],
            ),
            SizedBox(height: 10),
            // lessonPlan,
            // SizedBox(height: 6),
            // instructorInfo,
          ],
        ),
      ),
    );

    final viewSessionBtn = ElevatedButton(
      onPressed:
          (widget.schedule.textbooks ?? []).isEmpty ? null : onViewSessionClick,
      child: Text("View Session"),
      style: KStyles.roundedButton(Colors.yellow),
    );

    final buttons = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        viewSessionBtn,
      ],
    );

    final body = Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          info,
          SizedBox(height: 10),
          buttons,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.schedule.title ?? "")),
      body: body,
    );
  }
}
