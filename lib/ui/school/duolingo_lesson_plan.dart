import 'package:app_core/app_core.dart';
import 'package:app_core/ui/school/widget/self_study_view.dart';
import 'package:flutter/material.dart';

class _DuolingoData {
  final int row;
  final String label;
  final Widget icon;

  _DuolingoData({required this.row, required this.label, required this.icon});
}

class DuolingoLessonPlan extends StatefulWidget {
  @override
  _DuolingoLessonPlanState createState() => _DuolingoLessonPlanState();
}

class _DuolingoLessonPlanState extends State<DuolingoLessonPlan> {
  List<_DuolingoData>? plans;

  List<List<_DuolingoData>> get plansByRow => (this.plans ?? [])
      .fold<Set<int>>({}, (sum, elem) => sum..add(elem.row))
      .map((rowID) => (this.plans ?? []).where((e) => e.row == rowID).toList())
      .toList()
    ..sort((a, b) => a.first.row.compareTo(b.first.row));

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  void loadPlans() async {
    await Future.delayed(Duration(seconds: 1));

    final responseData = [
      _DuolingoData(
        row: 0,
        label: "Greeting 1",
        icon: Icon(Icons.female, size: 80),
      ),
      _DuolingoData(
        row: 1,
        label: "Numbers",
        icon: Icon(Icons.edit, size: 80),
      ),
      _DuolingoData(
        row: 1,
        label: "Name",
        icon: Icon(Icons.male, size: 80),
      ),
      _DuolingoData(
        row: 2,
        label: "Play Game",
        icon: Icon(Icons.gamepad, size: 80),
      ),
    ];

    setState(() => this.plans = responseData);
  }

  void onItemClick(_DuolingoData data) => toSelfStudy();

  void toSelfStudy() => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Scaffold(
            appBar: AppBar(title: Text("Study")),
            body: SelfStudyView(),
          )));

  @override
  Widget build(BuildContext context) {
    final listing = ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: this.plansByRow.length,
      itemBuilder: (_, i) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: this
            .plansByRow[i]
            .map((e) => _DuolingoListItem(e, onClick: onItemClick))
            .toList(),
      ),
      separatorBuilder: (_, __) => SizedBox(height: 20),
    );

    final body = listing;

    return KEmbedManager.of(context).isEmbed
        ? body
        : Scaffold(appBar: AppBar(), body: body);
  }
}

class _DuolingoListItem extends StatelessWidget {
  final _DuolingoData data;
  final Function(_DuolingoData)? onClick;

  const _DuolingoListItem(this.data, {this.onClick});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 8,
            ),
          ),
          child: this.data.icon,
        ),
        SizedBox(height: 10),
        Text(this.data.label, style: Theme.of(context).textTheme.headline5),
      ],
    );

    final body = InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: this.onClick == null ? null : () => this.onClick?.call(this.data),
      child: Container(padding: EdgeInsets.all(6), child: content),
    );

    return body;
  }
}
