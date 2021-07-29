import 'package:flutter/widgets.dart';

typedef KREMAction = Future Function(NavigatorState);

abstract class KREM {
  static const String APP = "app";
  static const String AMP = "amp";
  static const String PROMO = "promo";
  static const String CHAT = "chat";
  static const String USER = "user";
  static const String P2P = "p2p";
}
