import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_core/voip/kvoip_call.dart';
import 'package:app_core/voip/kvoip_comm_manager.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_voip_kit/call_state_type.dart';
import 'package:flutter_ios_voip_kit/flutter_ios_voip_kit.dart';

import 'kwebrtc_helper.dart';

class KCallKitHelper {
  static const String VOIP_PREF_KEY = "_voip_call_info";

  static late final KCallKitHelper instance = KCallKitHelper._internal();

  static final String tag = (KCallKitHelper).toString();
  static final FlutterIOSVoIPKit iosVoIPKit = FlutterIOSVoIPKit.instance;

  KVOIPCommManager? commManager;

  bool isInit = false; // for ios to delay answering dead app
  String? videoLogo;
  Function({String? chatID, String? refApp, String? refID})? getChat;
  Function({required KChatMessage message, List<String>? refPUIDs})?
      sendMessage;

  KCallKitHelper._internal();

  Future<String?> getVoIPToken() async => iosVoIPKit.getVoIPToken();

  Future<void> startListenSocket(String uuid, String callID) async {
    final deviceID = await KUtil.getDeviceID();
    final userJson = await KPrefHelper.get(KPrefHelper.CACHED_USER);
    if (userJson == null) return;

    final KUser user = KUser.fromJson(userJson);
    this.commManager = KVOIPCommManager(
      puid: user.puid!,
      deviceID: deviceID,
      nickname: user.firstName!,
    );

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

  Future<void> onCallAccepted(String uuid, String callID) async {
    if (this.isInit) {
      if (KWebRTCHelper.autoDisplayCallScreen)
        KWebRTCHelper.displayCallScreen(
          uuid,
          callID,
          autoPickup: true,
          videoLogo: this.videoLogo,
          getChat: this.getChat,
          sendMessage: this.sendMessage,
        );
    } else
      saveCallInfo(uuid, callID);
  }

  Future<void> onCallEnded(String uuid, String callID) async =>
      sendEndCallSocket(callID);

  void showNotificationCallAndroid(String callID, String callName) {
    startListenSocket("", callID);
    // if (KWebRTCHelper.autoDisplayCallScreen) {
    ConnectycubeFlutterCallKit.showCallNotification(
      sessionId: callID,
      callType: 1,
      callerId: 0,
      callerName: callName,
      opponentsIds: [0].toSet(),
    );
    // }
  }

  Future<dynamic> openVoipCallIfNeeded(BuildContext context) async {
    KVoipCallInfo? callInfo = await consumeCallInfo();
    if (KWebRTCHelper.autoDisplayCallScreen && callInfo != null) {
      await KPrefHelper.remove("callID");
      return Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => KVOIPCall.asReceiver(
          callInfo.callID!,
          callInfo.uuid!,
          autoPickup: true,
          videoLogo: this.videoLogo,
          chatroomData: KChatroomData()
            ..getChat = this.getChat
            ..sendMessage = this.sendMessage,
        ),
      ));
    }
    return Future.value(null);
  }

  void init({
    String? videoLogo,
    Function({String? chatID, String? refApp, String? refID})? getChat,
    Function({required KChatMessage message, List<String>? refPUIDs})?
        sendMessage,
  }) {
    this.videoLogo = videoLogo;
    this.getChat = getChat;
    this.sendMessage = sendMessage;
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
      ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated = (
        sessionId,
        callType,
        callerId,
        callerName,
        opponentsIds,
      ) {
        return onCallEnded("", sessionId);
      };

      ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated = (
        sessionId,
        callType,
        callerId,
        callerName,
        opponentsIds,
      ) {
        return saveCallInfo("", sessionId);
      };

      ConnectycubeFlutterCallKit.initMessagesHandler();
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
    final json = await KPrefHelper.get(VOIP_PREF_KEY);
    var result;
    try {
      result = KVoipCallInfo.fromJson(json);
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
  Future<void> _onCallAccepted(
    String sessionId,
    int callType,
    int callerId,
    String? callerName,
    Set<int>? opponentsIds,
  ) =>
      onCallAccepted("", sessionId);

  Future<void> _onCallRejected(
    String sessionId,
    int callType,
    int callerId,
    String? callerName,
    Set<int>? opponentsIds,
  ) =>
      onCallEnded("", sessionId);
}
