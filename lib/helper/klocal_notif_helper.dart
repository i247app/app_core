import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:app_core/helper/khost_config.dart';
import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/helper/ktoast_helper.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/kfull_notification.dart';
import 'package:app_core/model/knotif_data.dart';
import 'package:app_core/model/kpush_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class KLocalNotifHelper {
  static const bool BLOCKED_BANNERS_AS_TOAST = false;
  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  // TODO replace with smarter system
  static final Map<String, int> _blockedBannersDepth = {
    KPushData.APP_GIG_NOTIFY: 1,
    KPushData.APP_GIG_ASSIGN: 1,
    KPushData.APP_GIG_STANDBY_ASSIGN: 1,
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

  static bool isBannerBlocked(String? app) =>
      app != null && (_blockedBannersDepth[app] ?? 0) > 0;

  static void _logBlockDepth(String? app) {
    String msg;
    if (app == null) {
      msg = "anonymous notification - NOT BLOCKING";
    } else {
      msg = "banner block depth - ${_blockedBannersDepth[app]}";
    }
    print("LocalNotifHelper :: $msg");
  }

  static Future<void> setupLocalNotifications(
    String androidIcon, {
    DidReceiveNotificationResponseCallback? onSelectNotification,
  }) async {
    print("fcm_helper => setupLocalNotifications fired");

    if (Platform.isAndroid) {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings(androidIcon);
    final ios = DarwinInitializationSettings();
    final platform = InitializationSettings(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin!.initialize(
      platform,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
  }

  static void showNotification(
    KFullNotification msg, {
    required String androidIcon,
    DidReceiveNotificationResponseCallback? onSelectNotification,
    bool obeyBlacklist = false,
  }) async {
    final KNotifData? notif = msg.notification;
    final String? app = msg.app;
    if (notif == null
        // || app == null
        ) {
      print(
          "KLocalNotifHelper.showNotification validation fail - notif=$notif");
      return;
    }

    /// Pretty hacky but FOR NOW don't display blocked banners
    _logBlockDepth(app);
    if (isBannerBlocked(app) && obeyBlacklist) {
      print("LocalNotifHelper - blocked banner for app '$app'");
      if (!KHostConfig.isReleaseMode && BLOCKED_BANNERS_AS_TOAST) {
        KToastHelper.show("data app $app");
      }
      return;
    }

    print("KFCMHelper._showNotification attempt to display banner");
    final android = AndroidNotificationDetails(
      "91512",
      "chao",
      channelDescription: "chao",
      importance: Importance.max,
      priority: Priority.max,
      enableLights: true,
      enableVibration: true,
    );

    final iOS = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final platform = NotificationDetails(android: android, iOS: iOS);

    print(
        "LocalNotifHelper.showNotification - showing ${KUtil.prettyJSON(notif)}");

    if (KStringHelper.isExist(notif.title ?? "")) {
      if (_flutterLocalNotificationsPlugin == null) {
        await setupLocalNotifications(
          androidIcon,
          onSelectNotification: onSelectNotification,
        );
      }
      final rng = new Random();
      await _flutterLocalNotificationsPlugin!.show(
        rng.nextInt(100000),
        notif.title,
        notif.body,
        platform,
        payload: jsonEncode(msg.data ?? {}),
      );

      print("LocalNotifHelper - DISPLAYING NOTIFICATION BANNER");
    } else {
      print("LocalNotifHelper - no title NOT DISPLAYING NOTIFICATION BANNER");
    }
  }
}
