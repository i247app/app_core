import 'dart:convert';

import 'package:app_core/helper/globals.dart';
import 'package:app_core/helper/host_config.dart';
import 'package:app_core/helper/rem_helper.dart';
import 'package:app_core/helper/session_data.dart';
import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/helper/toast_helper.dart';
import 'package:app_core/helper/util.dart';
import 'package:app_core/model/full_notification.dart';
import 'package:app_core/model/notif_data.dart';
import 'package:app_core/model/push_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class LocalNotifHelper {
  static const bool BLOCKED_BANNERS_AS_TOAST = false;

  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  // TODO replace with smarter system
  static final Map<String, int> _blockedBannersDepth = {
    AppCorePushData.APP_GIG_NOTIFY: 1,
    AppCorePushData.APP_GIG_ASSIGN: 1,
    AppCorePushData.APP_GIG_BOOK: 1,
    AppCorePushData.APP_SESSION_NOTIFY: 1,
    AppCorePushData.APP_PUSH_PING_NOTIFY: 1,
    AppCorePushData.APP_P2P_CALL_NOTIFY: 1,
    AppCorePushData.APP_CONFETTI_NOTIFY: 1,
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

  static Future<void> setupLocalNotifications() async {
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
            AppCoreSessionData.hasActiveSession)
          AppCoreREMHelper.from(payload, "LocalNotifHelper.setupLocalNotifications")
              ?.call(appCoreNavigatorKey.currentState!);
      },
    );
  }

  static void showNotification(
      AppCoreFullNotification? msg, {
    bool obeyBlacklist = false,
  }) async {
    AppCoreNotifData? notif = msg?.notification;
    String? app = msg?.app;
    if (notif == null || app == null) return;

    /// Pretty hacky but FOR NOW don't display blocked banners
    _logBlockDepth(app);
    if (isBannerBlocked(app) && obeyBlacklist == true) {
      print("LocalNotifHelper - blocked banner for app '$app'");
      if (!AppCoreHostConfig.isReleaseMode && BLOCKED_BANNERS_AS_TOAST)
        AppCoreToastHelper.show("data app $app");
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
        "LocalNotifHelper.showNotification - showing ${AppCoreUtil.prettyJSON(notif)}");

    if (AppCoreStringHelper.isExist(notif.title ?? "")) {
      if (_flutterLocalNotificationsPlugin == null)
        await setupLocalNotifications();

      await _flutterLocalNotificationsPlugin!.show(
        0,
        notif.title,
        notif.body,
        platform,
        payload: jsonEncode(msg?.data ?? {}),
      );

      print("LocalNotifHelper - DISPLAYING NOTIFICATION BANNER");
    } else {
      print("LocalNotifHelper - no title NOT DISPLAYING NOTIFICATION BANNER");
    }
  }
}
