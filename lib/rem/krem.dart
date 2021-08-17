import 'package:flutter/widgets.dart';

typedef KREMAction = Future Function(NavigatorState);

abstract class KREM {
  // common
  static const String APP = "app";
  static const String CHAT = "chat";
  static const String USER = "user";
  static const String P2P = "p2p";
  static const String FLASH = "flash";

  // chao
  static const String AMP = "amp";
  static const String PROMO = "promo";

  // schoolbird
  static const String GIG = "gig";
}
