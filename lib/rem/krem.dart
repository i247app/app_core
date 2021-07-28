import 'package:flutter/widgets.dart';

typedef KREMAction = Future Function(NavigatorState);

class KREMPath {
  final String head;
  final String full;

  const KREMPath(this.head, this.full);
}

abstract class KREM {
  static const String APP = "app";
}
