import 'package:app_core/app_core.dart';

abstract class KAppNavHelper {
  // core
  static int get chat => KSessionData.appNav?.chatAppMode ?? KAppNav.OFF;

  static int get pay => KSessionData.appNav?.payAppMode ?? KAppNav.OFF;

  static int get feed => KSessionData.appNav?.feedAppMode ?? KAppNav.OFF;

  // Chao
  static int get amp => KSessionData.appNav?.ampAppMode ?? KAppNav.OFF;

  static int get reward => KSessionData.appNav?.rewardAppMode ?? KAppNav.OFF;

  static int get splash => KSessionData.appNav?.splashMode ?? KAppNav.OFF;

  // Schoolbird
  static int get gig => KSessionData.appNav?.gigAppMode ?? KAppNav.OFF;

  static int get study => KSessionData.appNav?.studyAppMode ?? KAppNav.OFF;

  static int get classes => KSessionData.appNav?.classAppMode ?? KAppNav.OFF;

  static int get university =>
      KSessionData.appNav?.universityAppMode ?? KAppNav.OFF;

  static int get profile =>
      KSessionData.appNav?.profileAppMode ?? KAppNav.OFF;

  static int get hero => KSessionData.appNav?.heroAppMode ?? KAppNav.OFF;

  static int get headstart =>
      KSessionData.appNav?.headstartAppMode ?? KAppNav.OFF;
}
