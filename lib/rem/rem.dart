import 'package:flutter/widgets.dart';

typedef REMAction = Future Function(NavigatorState);

class REMPath {
  final String head;
  final String full;

  const REMPath(this.head, this.full);
}

abstract class REM {
  static const String APP = "app";
}
