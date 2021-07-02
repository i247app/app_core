import 'dart:async';
import 'dart:convert';

// import 'package:app_core/ui/voip/voip_call.dart';
import 'package:app_core/ui/voip/simple_websocket.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_core/helper/session_data.dart';
import 'package:app_core/model/host_info.dart';

enum WebRTCCallType { video, audio }

abstract class WebRTCHelper {
  static const String CATEGORY_VIDEO = "1000";
  static const String CATEGORY_AUDIO = "1001";

  static int _autoDisplayCallScreenDepth = 0;

  static bool get autoDisplayCallScreen => _autoDisplayCallScreenDepth == 0;

  static HostInfo get turnHostInfo => SessionData.webRTCHostInfo;

  static List<Permission> get requiredPermissions => [
        Permission.camera,
        Permission.microphone,
      ];

  static void allowAutoDisplayCallScreen() => _autoDisplayCallScreenDepth++;

  static void blockAutoDisplayCallScreen() => _autoDisplayCallScreenDepth--;

  // static Future displayCallScreen(
  //   String uuid,
  //   String callID, {
  //   bool autoPickup: false,
  // }) {
  //   Future fut;
  //   if (StringHelper.isExist(callID)) {
  //     fut = (() async {
  //       ThrottleHelper.throttle(
  //         () {
  //           chaoNavigatorKey.currentState?.push(MaterialPageRoute(
  //               builder: (ctx) =>
  //                   VOIPCall.asReceiver(callID, uuid, autoPickup: autoPickup)));
  //         },
  //         throttleID: "tutoring_chat_answer_p2p_call",
  //       ).call();
  //     })();
  //   } else
  //     fut = Future.value(null);
  //   return fut;
  // }

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

  static Future<SimpleWebSocket> getWebsocket({
    required void Function() onOpen,
    required void Function(Map<String, dynamic>) onMessage,
    required void Function(int, String) onClose,
  }) async {
    final hi = turnHostInfo;
    final url = 'https://${hi.hostname}:${hi.port}/ws';
    final _socket = SimpleWebSocket(url);

    _socket.onOpen = onOpen;

    _socket.onMessage = (raw) {
      final Map<String, dynamic> message = jsonDecode(raw);
      onMessage.call(message);
    };

    _socket.onClose = onClose;
    return _socket;
  }

  static void releaseWebsocket(SimpleWebSocket socket) {
    try {
      socket.close();
    } catch (e) {}
  }
}
