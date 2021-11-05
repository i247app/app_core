import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:app_core/app_core.dart';

class KStopwatchLabel extends StatefulWidget {
  final DateTime since;

  final TextStyle? style;
  final Duration? refreshInterval;
  final String Function(Duration)? formatter;
  final String Function(Duration)? doneFormatter;
  final bool countUp;

  const KStopwatchLabel(
    this.since, {
    this.style,
    this.refreshInterval,
    this.formatter,
    this.doneFormatter,
    this.countUp = false,
  });

  @override
  _KStopwatchLabelState createState() => _KStopwatchLabelState();
}

class _KStopwatchLabelState extends State<KStopwatchLabel> {
  Timer? timer;

  Duration get delta => widget.countUp
      ? DateTime.now().difference(widget.since)
      : widget.since.difference(DateTime.now());

  String get stopwatchText => (this.isDone && widget.doneFormatter != null)
      ? widget.doneFormatter!.call(this.delta)
      : (widget.formatter ?? KUtil.prettyStopwatch).call(this.delta);

  bool get isDone => this.delta.isNegative || this.delta == Duration.zero;

  @override
  void initState() {
    super.initState();
    this.timer = Timer.periodic(
      widget.refreshInterval ?? Duration(milliseconds: 450),
      (_) {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    this.timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = Text(
      this.stopwatchText,
      style: (widget.style ?? TextStyle())
          .copyWith(fontFeatures: [FontFeature.tabularFigures()]),
    );

    return body;
  }
}
