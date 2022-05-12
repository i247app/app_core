import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kcall_control_stream_helper.dart';
import 'package:app_core/helper/kcall_stream_helper.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_voip_kit/call_state_type.dart';
import 'package:flutter_ios_voip_kit/flutter_ios_voip_kit.dart';

class KCallKitHelper {
  static const String VOIP_PREF_KEY = "_voip_call_info";

  static late final KCallKitHelper instance = KCallKitHelper._internal();

  static final String tag = (KCallKitHelper).toString();
  static final FlutterIOSVoIPKit iosVoIPKit = FlutterIOSVoIPKit.instance;

  KVOIPCommManager? commManager;

  bool isInit = false; // for ios to delay answering dead app
  bool isCalling = false; // for ios to delay answering dead app
  String? videoLogo;

  KCallKitHelper._internal();

  Future<String?> getVoIPToken() async => iosVoIPKit.getVoIPToken();

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
    this.commManager?.sayGoodbye(callID);
    Future.delayed(Duration(seconds: 3), this.commManager?.close);
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

  Future onCallEnded(String uuid, String callID) async =>
      sendEndCallSocket(callID);

  void showNotificationCallAndroid(String callID, String callName) {
    startListenSocket("", callID);
    // if (KWebRTCHelper.autoDisplayCallScreen) {
    final callEvent = CallEvent(
      sessionId: callID,
      callType: 1,
      callerId: 0,
      callerName: callName,
      opponentsIds: [0].toSet(),
    );
    ConnectycubeFlutterCallKit.showCallNotification(callEvent
        // sessionId: callID,
        // callType: 1,
        // callerId: 0,
        // callerName: callName,
        // opponentsIds: [0].toSet(),
        );
    // }
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
      // return Navigator.of(context).push(MaterialPageRoute(
      //   builder: (ctx) => KVOIPCall.asReceiver(
      //     callInfo.callID!,
      //     callInfo.uuid!,
      //     autoPickup: true,
      //     videoLogo: this.videoLogo,
      //     chatroomCtrl: KChatroomController(),
      //   ),
      // ));
    }
    return Future.value(null);
  }

  void init({String? videoLogo}) {
    this.videoLogo = videoLogo;
    iosVoIPKit.onDidRejectIncomingCall = (
      String uuid,
      String callerId,
      String receiverId,
      String callerName,
    ) {
      onCallEnded(uuid, callerId);
      iosVoIPKit.endCall(
        uuid: uuid,
        callerId: callerId,
        receiverId: receiverId,
        callerName: callerName,
      );
    };

    iosVoIPKit.onDidAcceptIncomingCall = (
      String uuid,
      String callerId,
      String receiverId,
      String callerName,
    ) {
      onCallAccepted(uuid, callerId);
      print('🎈 example: onDidAcceptIncomingCall $uuid, $callerId');
      iosVoIPKit.acceptIncomingCall(callerState: CallStateType.calling);
      iosVoIPKit.callConnected();
    };

    iosVoIPKit.onDidReceiveIncomingPush = (
      String uuid,
      String callerId,
      String receiverId,
      String callerName,
    ) {
      print("CALL_KIT_HELPER: onDidReceiveIncomingPush $callerId");
      startListenSocket(uuid, callerId);
    };

    ConnectycubeFlutterCallKit.instance.init(
      onCallAccepted: _onCallAccepted,
      onCallRejected: _onCallRejected,
    );
  }

  void initBackground(RemoteMessage message) {
    KPushData? data;
    try {
      data = KPushData.fromJson(Map<String, dynamic>.from(message.data));
    } catch (e) {
      print(e.toString());
    }

    // send to rebroadcast helper
    if (data != null && data.app == KPushData.APP_P2P_CALL_NOTIFY) {
      ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
          (CallEvent callEvent
              // sessionId,
              // callType,
              // callerId,
              // callerName,
              // opponentsIds,
              ) {
        return onCallEnded("", callEvent.sessionId);
      };

      ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
          (CallEvent callEvent
              // sessionId,
              // callType,
              // callerId,
              // callerName,
              // opponentsIds,
              ) {
        return saveCallInfo("", callEvent.sessionId);
      };

      // ConnectycubeFlutterCallKit.initMessagesHandler();
      ConnectycubeFlutterCallKit.initEventsHandler();
      showNotificationCallAndroid(data.id ?? "", data.callerName ?? "");
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
    if (Platform.isAndroid) {
      ConnectycubeFlutterCallKit.reportCallEnded(sessionId: callerId);
      ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
    } else {
      await iosVoIPKit.endCall(
        uuid: uuid,
        callerId: callerId,
        callerName: callerName,
        receiverId: receiverId,
      );
    }
  }

  Future<void> endCall(
    String uuid,
    String callerId,
    String receiverId,
    String callerName,
  ) async {
    if (Platform.isAndroid) {
      ConnectycubeFlutterCallKit.reportCallEnded(sessionId: callerId);
      ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
    } else {
      await iosVoIPKit.endCall(
        uuid: uuid,
        callerId: callerId,
        callerName: callerName,
        receiverId: receiverId,
      );
    }
  }

  Future<void> rejectCall(
    String uuid,
    String callerId,
    String receiverId,
    String callerName,
  ) async {
    if (Platform.isAndroid) {
      ConnectycubeFlutterCallKit.reportCallEnded(sessionId: callerId);
      ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
    } else {
      await iosVoIPKit.endCall(
        uuid: uuid,
        callerId: callerId,
        callerName: callerName,
        receiverId: receiverId,
      );
    }
  }

  /// Event Listener Callbacks for 'connectycube_flutter_call_kit'
  Future _onCallAccepted(CallEvent callEvent
          // String sessionId,
          // int callType,
          // int callerId,
          // String? callerName,
          // Set<int>? opponentsIds,
          ) =>
      onCallAccepted("", callEvent.sessionId);

  Future _onCallRejected(CallEvent callEvent
          // String sessionId,
          // int callType,
          // int callerId,
          // String? callerName,
          // Set<int>? opponentsIds,
          ) =>
      onCallEnded("", callEvent.sessionId);
}
