import 'dart:convert';

import 'package:app_core/helper/kglobals.dart';
import 'package:app_core/helper/khost_config.dart';
import 'package:app_core/helper/krem_helper.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/helper/ktoast_helper.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/kfull_notification.dart';
import 'package:app_core/model/knotif_data.dart';
import 'package:app_core/model/kpush_data.dart';
import 'package:app_core/rem/mgr/rem_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class KLocalNotifHelper {
  static const bool BLOCKED_BANNERS_AS_TOAST = false;

  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  // TODO replace with smarter system
  static final Map<String, int> _blockedBannersDepth = {
    KPushData.APP_GIG_NOTIFY: 1,
    KPushData.APP_GIG_ASSIGN: 1,
    KPushData.APP_GIG_BOOK: 1,
    KPushData.APP_SESSION_NOTIFY: 1,
    KPushData.APP_PUSH_PING_NOTIFY: 1,
    KPushData.APP_P2P_CALL_NOTIFY: 1,
    KPushData.APP_CONFETTI_NOTIFY: 1,
  };

  static void blockBanner(String app) {
    _blockedBannersDepth.putIfAbsent(app, () => 0);
    final current = _blockedBannersDepth[app]!;
    _blockedBannersDepth[app] = current + 1;
    print("BLOCK - current = $current");
    _logBlockDepth(app);
  }

  static void unblockBanner(String app) {
    _blockedBannersDepth.putIfAbsent(app, () => 0);
    final current = _blockedBannersDepth[app]!;
    _blockedBannersDepth[app] = current - 1;
    print("UNBLOCK - current = $current");
    _logBlockDepth(app);
  }

  static bool isBannerBlocked(String app) =>
      (_blockedBannersDepth[app] ?? 0) > 0;

  static void _logBlockDepth(String app) => print(
      "LocalNotifHelper :: banner block depth - ${_blockedBannersDepth[app]}");

  static Future<void> setupLocalNotifications(REMManager dispatcher) async {
    print("fcm_helper => setupLocalNotifications fired");

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings("chao_notif_sm_transparent");
    final ios = IOSInitializationSettings();
    final platform = InitializationSettings(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin!.initialize(
      platform,
      onSelectNotification: (payload) async {
        if (payload != null &&
            // Removes a bug where app repeatedly triggers this method on launch
            KSessionData.hasActiveSession)
          REMCoreHelper.from(
            dispatcher,
            payload,
            "LocalNotifHelper.setupLocalNotifications",
          )?.call(kNavigatorKey.currentState!);
      },
    );
  }

  static void showNotification(
    KFullNotification? msg, {
    REMManager? remDispatcher,
    bool obeyBlacklist = false,
  }) async {
    KNotifData? notif = msg?.appCoreNotification;
    String? app = msg?.app;
    if (notif == null || app == null) return;

    /// Pretty hacky but FOR NOW don't display blocked banners
    _logBlockDepth(app);
    if (isBannerBlocked(app) && obeyBlacklist == true) {
      print("LocalNotifHelper - blocked banner for app '$app'");
      if (!KHostConfig.isReleaseMode && BLOCKED_BANNERS_AS_TOAST)
        KToastHelper.show("data app $app");
      return;
    }

    print("FCMHelper._showNotification attempt to display banner");
    final android = AndroidNotificationDetails(
      "91512",
      "chao",
      "chao",
      importance: Importance.max,
      priority: Priority.max,
      enableLights: true,
      enableVibration: true,
    );

    final iOS = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final platform = NotificationDetails(android: android, iOS: iOS);

    print(
        "LocalNotifHelper.showNotification - showing ${KUtil.prettyJSON(notif)}");

    if (KStringHelper.isExist(notif.title ?? "")) {
      if (_flutterLocalNotificationsPlugin == null && remDispatcher != null)
        await setupLocalNotifications(remDispatcher);

      await _flutterLocalNotificationsPlugin!.show(
        0,
        notif.title,
        notif.body,
        platform,
        payload: jsonEncode(msg?.appCoreData ?? {}),
      );

      print("LocalNotifHelper - DISPLAYING NOTIFICATION BANNER");
    } else {
      print("LocalNotifHelper - no title NOT DISPLAYING NOTIFICATION BANNER");
    }
  }
}
