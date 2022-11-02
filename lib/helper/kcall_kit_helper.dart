import 'dart:convert';
import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kcall_control_stream_helper.dart';
import 'package:app_core/helper/kcall_stream_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';

class KCallKitHelper {
  static const String VOIP_PREF_KEY = "_voip_call_info";

  static late final KCallKitHelper instance = KCallKitHelper._internal();

  static final String tag = (KCallKitHelper).toString();

  KVOIPCommManager? commManager;

  bool isInit = false; // for ios to delay answering dead app
  bool isCalling = false; // for ios to delay answering dead app
  String? videoLogo;

  KCallKitHelper._internal();

  Future<String?> getVoIPToken() async => Platform.isAndroid
      ? Future.value(null)
      : ConnectycubeFlutterCallKit.getToken();

  Future<void> startListenSocket(String uuid, String callID) async {
    final deviceID = await KUtil.getDeviceID();
    final userJson =
        await KPrefHelper.get<Map<String, dynamic>>(KPrefHelper.CACHED_USER);
    if (userJson == null) return;

    final KUser user = KUser.fromJson(userJson);
    this.commManager = KVOIPCommManager(
        puid: user.puid!,
        deviceID: deviceID,
        nickname: user.firstName!,
        media: "video");

    this.commManager?.onStateChange = (SignalingState state) {
      if (state == SignalingState.CallStateBye ||
          state == SignalingState.CallStateRoomEmpty) {
        reportEndCallWithUUID(uuid, callID, "", "");
      }
    };

    await this.commManager?.connect(callID);
  }

  Future<void> sendEndCallSocket(String callID) async {
    commManager?.sayGoodbye(callID);
    Future.delayed(Duration(seconds: 3), commManager?.close);
  }

  Future onCallAccepted(String uuid, String callID) async {
    if (this.isInit) {
      KWebRTCHelper.displayCallScreen(
        uuid,
        callID,
        autoPickup: true,
        videoLogo: this.videoLogo,
      );
    } else
      saveCallInfo(uuid, callID);
  }

  Future onCallEnded(String uuid, String callID) async {
    await startListenSocket(uuid, callID);
    sendEndCallSocket(callID);
  }

  void showNotificationCallAndroid(String sessionId, int callType, int callId,
      String callerName, Set<int> opponentsIds, String userInfo) {
    final userInfoMap = Map<String, String>.from(jsonDecode(userInfo));

    CallEvent callEvent = CallEvent(
        sessionId: sessionId,
        callType: callType,
        callerId: callId,
        callerName: callerName,
        opponentsIds: opponentsIds,
        userInfo: userInfoMap);
    ConnectycubeFlutterCallKit.showCallNotification(callEvent);
  }

  Future<dynamic> openVoipCallIfNeeded(BuildContext context) async {
    KVoipCallInfo? callInfo = await consumeCallInfo();
    if (callInfo != null) {
      await KPrefHelper.remove("callID");

      final screen = KVOIPCall.asReceiver(
        callInfo.callID!,
        callInfo.uuid!,
        autoPickup: true,
        videoLogo: this.videoLogo,
        chatroomCtrl: KChatroomController(),
      );
      KCallControlStreamHelper.broadcast(KCallType.foreground);
      KCallStreamHelper.broadcast(screen);
    }
    return Future.value(null);
  }

  void init({String? videoLogo}) {
    this.videoLogo = videoLogo;

    ConnectycubeFlutterCallKit.instance.init(
      onCallAccepted: _onCallAccepted,
      onCallRejected: _onCallRejected,
    );

    ConnectycubeFlutterCallKit.instance
        .updateConfig(icon: "bird_green_logo", notificationIcon: "notif_icon");
  }

  void initBackground(RemoteMessage message) {
    KPushData? data;
    final messageData = message.data;
    messageData["call_type"] = messageData["call_type"] != null
        ? int.parse(messageData["call_type"])
        : null;
    messageData["caller_id"] = messageData["call_type"] != null
        ? int.parse(messageData["caller_id"])
        : null;
    try {
      data = KPushData.fromJson(Map<String, dynamic>.from(messageData));
    } catch (e) {
      print(e.toString());
    }

    // send to rebroadcast helper
    if (data != null && data.app == KPushData.APP_P2P_CALL_NOTIFY) {
      ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
          (CallEvent callEvent) {
        return onCallEnded(
            callEvent.sessionId, callEvent.userInfo!["callID"] as String);
      };

      ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
          (CallEvent callEvent) {
        return saveCallInfo(
            callEvent.sessionId, callEvent.userInfo!["callID"] as String);
      };

      // ConnectycubeFlutterCallKit.initMessagesHandler();
      ConnectycubeFlutterCallKit.initEventsHandler();
      showNotificationCallAndroid(
          data.sessionId ?? "",
          data.callType ?? 1,
          data.callerId ?? 0,
          data.callerName ?? "",
          (data.callOpponents ?? "")
              .split(",")
              .map((item) => int.parse(item))
              .toSet(),
          data.userInfo ?? "");
    }
  }

  Future<void> saveCallInfo(String uuid, String callId) async {
    final callInfo = KVoipCallInfo()
      ..uuid = uuid
      ..callID = callId;
    await KPrefHelper.put(VOIP_PREF_KEY, callInfo);
    print("CALL_KIT_HELPER: SAVED ID: $callId");
  }

  Future<KVoipCallInfo?> consumeCallInfo() async {
    final json = await KPrefHelper.get<Map<String, dynamic>>(VOIP_PREF_KEY);
    var result;
    try {
      result = KVoipCallInfo.fromJson(json!);
    } catch (e) {
      print(e.toString());
    } finally {
      KPrefHelper.remove(VOIP_PREF_KEY);
    }
    return result;
  }

  // call when opponent(s) end call
  Future<void> reportEndCallWithUUID(
    String uuid,
    String callerId,
    String receiverId,
    String callerName,
  ) async {
    ConnectycubeFlutterCallKit.reportCallEnded(sessionId: callerId);
    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
  }

  Future<void> endCall(
    String uuid,
    String callerId,
    String receiverId,
    String callerName,
  ) async {
    ConnectycubeFlutterCallKit.reportCallEnded(sessionId: uuid);
    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
  }

  Future<void> rejectCall(
    String uuid,
    String callerId,
    String receiverId,
    String callerName,
  ) async {
    ConnectycubeFlutterCallKit.reportCallEnded(sessionId: uuid);
    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
  }

  /// Event Listener Callbacks for 'connectycube_flutter_call_kit'
  Future _onCallAccepted(CallEvent event) {
    return onCallAccepted(event.sessionId, event.userInfo!["callID"] as String);
  }

  Future _onCallRejected(CallEvent event) {
    return onCallEnded(event.sessionId, event.userInfo!["callID"] as String);
  }
}
