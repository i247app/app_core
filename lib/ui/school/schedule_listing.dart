import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/lop_schedule.dart';
import 'package:app_core/ui/school/schedule_session_viewer.dart';
import 'package:flutter/material.dart';

class ScheduleListing extends StatefulWidget {
  @override
  _ScheduleListingState createState() => _ScheduleListingState();
}

class _ScheduleListingState extends State<ScheduleListing> {
  List<LopSchedule>? schedules;

  @override
  void initState() {
    super.initState();
    loadSchedules();
  }

  void loadSchedules() async {
    final response = await KServerHandler.getLopSchedules();
    setState(() => this.schedules = response.schedules ?? []);
  }

  void onScheduleClick(LopSchedule schedule, ScheduleSessionMode mode) async {
    final response = await KServerHandler.getSchedule(
      lopID: schedule.lopID ?? "",
      scheduleID: schedule.lopScheduleID ?? "",
    );

    if (response.isSuccess && (response.schedules ?? []).isNotEmpty) {
      final schedule = response.schedules!.first;
      if ((schedule.textbooks ?? []).isEmpty) {
        KSnackBarHelper.error("Missing a textbook");
        return;
      } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ScheduleSessionViewer(schedule)));
      }
    } else {
      KToastHelper.error("Failed to load course ${schedule.courseID}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final listing = ListView.separated(
      itemCount: (this.schedules ?? []).length,
      itemBuilder: (_, i) => _ScheduleItem(
        this.schedules![i],
        onClick: onScheduleClick,
      ),
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: KStyles.colorDivider,
      ),
    );

    final nothingHere = Center(
      child: Text(
        "No courses found",
        style: KStyles.normalText,
      ),
    );

    final body = this.schedules == null
        ? Container()
        : this.schedules!.isNotEmpty
            ? listing
            : nothingHere;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Courses"),
      ),
      body: body,
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final LopSchedule schedule;
  final Function(LopSchedule, ScheduleSessionMode) onClick;

  String get title => KFileHelper.basename(this.schedule.title ?? "_title");

  const _ScheduleItem(this.schedule, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    final body = Row(
      children: [
        Expanded(child: Text(this.title, style: KStyles.largeText)),
        SizedBox(width: 10),
        TextButton(
          onPressed: () =>
              this.onClick.call(this.schedule, ScheduleSessionMode.master),
          child: Text("As Teacher"),
        ),
      ],
    );

    return InkWell(
      onTap: () => this.onClick.call(this.schedule, ScheduleSessionMode.slave),
      child: Container(padding: EdgeInsets.all(10), child: body),
    );
  }
}
