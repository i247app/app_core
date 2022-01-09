import 'dart:async';
import 'dart:convert';

import 'package:app_core/helper/kcall_control_stream_helper.dart';
import 'package:app_core/helper/kcall_stream_helper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_core/app_core.dart';

enum KWebRTCCallType { video, audio }

abstract class KWebRTCHelper {
  static const String CATEGORY_VIDEO = "1000";
  static const String CATEGORY_AUDIO = "1001";

  static KHostInfo get turnHostInfo => KSessionData.webRTCHostInfo;

  static List<Permission> get requiredPermissions => [
        Permission.camera,
        Permission.microphone,
      ];

  static Future displayCallScreen(String uuid, String callID,
      {bool autoPickup: false, String? videoLogo}) {
    Future fut;
    if (KStringHelper.isExist(callID)) {
      fut = (() async {
        KThrottleHelper.throttle(
          () {
            if (KCallKitHelper.instance.isCalling) {
              final screen = KVOIPCall.asReceiver(
                callID,
                uuid,
                autoPickup: autoPickup,
                videoLogo: videoLogo,
              );

              KCallStreamHelper.broadcast(screen);
              KCallControlStreamHelper.broadcast(KCallType.foreground);
              // kNavigatorKey.currentState?.pushReplacement(MaterialPageRoute(
              //     builder: (ctx) => KVOIPCall.asReceiver(
              //           callID,
              //           uuid,
              //           autoPickup: autoPickup,
              //           videoLogo: videoLogo,
              //         )));
            } else {
              final screen = KVOIPCall.asReceiver(
                callID,
                uuid,
                autoPickup: autoPickup,
                videoLogo: videoLogo,
              );
              KCallStreamHelper.broadcast(screen);
              KCallControlStreamHelper.broadcast(KCallType.foreground);
              // kNavigatorKey.currentState?.push(MaterialPageRoute(
              //     builder: (ctx) => KVOIPCall.asReceiver(
              //           callID,
              //           uuid,
              //           autoPickup: autoPickup,
              //           videoLogo: videoLogo,
              //         )));
            }
          },
          throttleID: "tutoring_chat_answer_p2p_call",
        ).call();
      })();
    } else
      fut = Future.value(null);
    return fut;
  }

  static Future<bool> askForPermissions() async {
    bool status = true;
    for (Permission p in requiredPermissions) {
      final s = await p.request();
      status = status &&
          ([PermissionStatus.granted, PermissionStatus.limited].contains(s));
      if (!status) return false;
    }
    return status;
  }

  static Future<KSimpleWebSocket> getWebsocket({
    required void Function() onOpen,
    required void Function(Map<String, dynamic>) onMessage,
    required void Function(int, String) onClose,
  }) async {
    final hi = turnHostInfo;
    final url = 'https://${hi.hostname}:${hi.port}/ws';
    final _socket = KSimpleWebSocket(url);

    _socket.onOpen = onOpen;

    _socket.onMessage = (raw) {
      final Map<String, dynamic> message = jsonDecode(raw);
      onMessage.call(message);
    };

    _socket.onClose = onClose;
    return _socket;
  }

  static void releaseWebsocket(KSimpleWebSocket socket) {
    try {
      socket.close();
    } catch (e) {}
  }

  static String buildWebRTCClientID({
    required String puid,
    required String deviceID,
  }) =>
      "$puid::$deviceID";
}
