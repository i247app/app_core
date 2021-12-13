import 'package:app_core/app_core.dart';

abstract class KAppNavHelper {
  // Chao
  static int get amp => KSessionData.appNav?.ampAppMode ?? KAppNav.OFF;

  static int get pay => KSessionData.appNav?.payAppMode ?? KAppNav.OFF;

  static int get reward => KSessionData.appNav?.rewardAppMode ?? KAppNav.OFF;

  static int get chat => KSessionData.appNav?.chatAppMode ?? KAppNav.OFF;

  // Schoolbird
  static int get gig => KSessionData.appNav?.gigAppMode ?? KAppNav.OFF;

  static int get study => KSessionData.appNav?.studyAppMode ?? KAppNav.OFF;

  static int get classes => KSessionData.appNav?.classAppMode ?? KAppNav.OFF;

  static int get university =>
      KSessionData.appNav?.universityAppMode ?? KAppNav.OFF;
}
