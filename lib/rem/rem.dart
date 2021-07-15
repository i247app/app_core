import 'package:app_core/rem/rem_generator.dart';
import 'package:flutter/widgets.dart';

typedef AppCoreREMAction = Future Function(NavigatorState);

class AppCoreREMPath {
  final String head;
  final String full;

  const AppCoreREMPath(this.head, this.full);

  String get appAction => AppCoreREMGenerator.buildAppAction(this);
}

abstract class AppCoreREM {
  static const String APP = "app";
  static const String CHAT = "chat";
  static const String USER = "user";
  static const String P2P = "p2p";
}
