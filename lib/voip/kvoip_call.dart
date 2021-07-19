import 'dart:async';
import 'dart:io';

import 'package:app_core/header/kassets.dart';
import 'package:app_core/header/kstyles.dart';
import 'package:app_core/helper/kcall_kit_helper.dart';
import 'package:app_core/helper/knotif_stream_helper.dart';
import 'package:app_core/helper/ksnackbar_helper.dart';
import 'package:app_core/helper/kwebrtc_helper.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:app_core/voip/kvoip_comm_manager.dart';
import 'package:app_core/voip/widget/kp2p_button_view.dart';
import 'package:app_core/voip/widget/kp2p_video_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock/wakelock.dart';
import 'package:app_core/app_core.dart';

enum _CallPerspective { sender, receiver }
enum _CallState { ws_error, init, waiting, in_progress, ended }

class KVOIPCall extends StatefulWidget {
  final _CallPerspective perspective;
  final bool autoPickup;
  final KUser? refUser;
  final List<String>? invitePUIDs;
  final String? callID;
  final String? uuid;
  final KChatroomController? chatroomCtrl;
  final String? videoLogo;
  final Function(List<String> refPUIDs, String callID, String uuid)? notify;
  final Function({String? puid})? getUsers;

  KVOIPCall({
    required this.perspective,
    this.refUser,
    this.invitePUIDs,
    this.callID,
    this.uuid,
    this.autoPickup = false,
    this.chatroomCtrl,
    this.videoLogo,
    this.notify,
    this.getUsers,
  });

  KVOIPCall.asSender(
    KUser refUser, {
    required this.notify,
    List<String>? invitePUIDs,
    this.chatroomCtrl,
    String? videoLogo,
    Function({String? puid})? getUsers,
  })  : this.refUser = refUser,
        this.invitePUIDs = invitePUIDs,
        this.perspective = _CallPerspective.sender,
        this.autoPickup = false,
        this.uuid = Uuid().v4(),
        this.callID = null,
        this.getUsers = getUsers,
        this.videoLogo = videoLogo;

  KVOIPCall.asReceiver(
    String callID,
    String uuid, {
    this.autoPickup = false,
    this.videoLogo,
    this.chatroomCtrl,
    Function({String? puid})? getUsers,
  })  : this.refUser = null,
        this.invitePUIDs = null,
        this.perspective = _CallPerspective.receiver,
        this.callID = callID,
        this.uuid = uuid,
        this.getUsers = getUsers,
        this.notify = null;

  @override
  _KVOIPCallState createState() => _KVOIPCallState();
}

class _KVOIPCallState extends State<KVOIPCall>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final StreamSubscription streamSub;
  late AnimationController _slidingAnimationController;
  late Animation<Offset> _slidingAnimation;

  final PanelController panelCtrl = PanelController();
  final Set<int> receivedCodes = {};
  final Map<String, RTCVideoRenderer> remoteRenderers = {};

  late KChatroomController? chatCtrl =
      widget.chatroomCtrl == null ? null : widget.chatroomCtrl!;
  late _CallState callState = widget.perspective == _CallPerspective.sender
      ? _CallState.waiting
      : _CallState.init;

  KVOIPCommManager? commManager;
  Timer? timer;
  Timer? panelTimer;

  String? infoMsg;
  int? infoCode;
  RTCVideoRenderer? localRenderer;

  bool get isAccepted => widget.autoPickup;
  bool isMySoundEnabled = true;
  bool isMySpeakerEnabled = true;
  bool isMyCameraEnabled = true;
  bool isOtherSoundEnabled = true;
  bool isOtherCameraEnabled = true;
  bool isVideoInitialized = false;
  bool isPanelOpen = false;

  String get _uuid => widget.uuid ?? Uuid().v4();

  bool get isAudioCall => false;

  bool get isChatEnabled => this.chatCtrl != null;

  String? get chatID =>
      widget.chatroomCtrl?.value.chatID ?? this.commManager?.session?.chatID;

  String? get refApp =>
      widget.chatroomCtrl?.value.refApp ?? this.commManager?.session?.refApp;

  String? get refID =>
      widget.chatroomCtrl?.value.refID ?? this.commManager?.session?.refID;

  String? get refAvatarURL => widget.perspective == _CallPerspective.sender
      ? widget.refUser?.avatarURL
      : this.commManager?.session?.adminAvatarURL;

  String? get refName => widget.perspective == _CallPerspective.sender
      ? widget.refUser?.fullName
      : this.commManager?.session?.adminName;

  String? get myPUID => KSessionData.me?.puid;

  String? get myName => KSessionData.me?.firstName;

  String? get refPUID => widget.refUser?.puid;

  String get infoLabel {
    if (this.hasPeerError) {
      final refName = widget.refUser?.firstName ?? "The other person";
      return "$refName left the call";
    } else {
      final prefix = KHostConfig.isReleaseMode ? "" : "[${this.infoCode}] ";
      return KStringHelper.isEmpty(this.infoMsg)
          ? ""
          : "$prefix${this.infoMsg}...";
    }
  }

  bool get isReceiverReadyToPickup =>
      this.receivedCodes.contains(KVOIPCommManager.CODE_INCOMING_CALL);

  bool get hasPeerError =>
      this.receivedCodes.contains(KVOIPCommManager.NO_PEER);

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    WidgetsBinding.instance?.addObserver(this);

    this._slidingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..forward();
    this._slidingAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(new CurvedAnimation(
      parent: _slidingAnimationController,
      curve: Curves.easeInOut,
    ));

    this.streamSub = KNotifStreamHelper.stream.listen(notifListener);

    // White status bar icons & black software buttons
    SystemChrome.setSystemUIOverlayStyle(KStyles.systemStyle.copyWith(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: KStyles.black,
    ));

    KWebRTCHelper.blockAutoDisplayCallScreen();

    requestPermission()
        .whenComplete(initRenderers)
        .whenComplete(setup)
        .whenComplete(() {
      if (widget.autoPickup) answerCall();
    });
  }

  @override
  void dispose() {
    if (!KHostConfig.isReleaseMode) print("P2PCall.dispose fired...");
    this._slidingAnimationController.dispose();

    Wakelock.disable();
    WidgetsBinding.instance?.removeObserver(this);

    KWebRTCHelper.allowAutoDisplayCallScreen();

    stopRingtone();
    KCallKitHelper.instance.endCall(this._uuid, "", "", "");

    SystemChrome.setSystemUIOverlayStyle(KStyles.systemStyle);
    this.timer?.cancel();
    this.panelTimer?.cancel();
    this.streamSub.cancel();
    this.commManager?.close();
    this.localRenderer?.dispose();
    this.remoteRenderers.forEach((_, rr) => rr.dispose());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused)
      this.commManager?.onPauseState();
    else if (state == AppLifecycleState.resumed)
      this.commManager?.onResumedState();
  }

  static Future<void> requestPermission() async {
    // ios
    // try {
    //   await AppTrackingTransparency.requestTrackingAuthorization();
    // } catch (e) {}

    // local and push ask for iOS
    try {
      // await KLocalNotifHelper.setupLocalNotifications();
    } catch (e) {}

    // setup location permission ask
    try {
      await KLocationHelper.askForPermission();
    } catch (e) {}

    // audio and video
    try {
      await KWebRTCHelper.askForPermissions();
    } catch (e) {}
  }

  void notifListener(KFullNotification notification) {
    switch (notification.app) {
      case KPushData.APP_P2P_CALL_NOTIFY:
        // final bool isDifferentCall =
        //     notification.data?.otherId != this.commManager?.session?.id;

        // If this call has already ended, respond to incoming call
        if (notification.appCoreData?.id != null &&
            this.callState == _CallState.ended) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => KVOIPCall.asReceiver(
                  notification.appCoreData!.id!,
                  notification.appCoreData!.uuid!,
                  autoPickup: true,
                  videoLogo: widget.videoLogo)));

          // safePop();
          // KWebRTCHelper.displayCallScreen(notification.data!.id!);
        }
        break;
    }
  }

  void setup() async => setupCommManager(this.myPUID!, this.myName!);

  void safePop([final result]) =>
      mounted ? Navigator.of(context).pop(result) : null;

  Future initRenderers() async {
    final permissionsGranted = await KWebRTCHelper.askForPermissions();
    if (permissionsGranted) {
      this.localRenderer = RTCVideoRenderer();
      return Future.wait([this.localRenderer!.initialize()])
        ..whenComplete(() => setState(() => this.isVideoInitialized = true));
    } else {
      print("SAFE POP because permissions not granted");
      safePop();
    }
  }

  Future setupCommManager(String puid, String name) async {
    try {
      this.commManager = KVOIPCommManager(
        puid: puid,
        deviceID: await KUtil.getDeviceID(),
        nickname: name,
      );
    } catch (e) {
      KSnackBarHelper.error("Websocket connection failed");
      safePop();
      return null;
    }

    this.commManager?.onStateChange = (SignalingState ss) {
      genericSignalListener(ss);
      Function.apply(
        widget.perspective == _CallPerspective.sender
            ? senderSignalListener
            : receiverSignalListener,
        [ss],
      );
    };

    this.commManager?.onCallInfo = onCallStatusUpdate;
    this.commManager?.onCallError = onCallError;

    this.commManager?.onLocalStream = ((peerID, stream) =>
        setState(() => this.localRenderer?.srcObject = stream));

    this.commManager?.onAddRemoteStream = ((peerID, stream) async {
      final remoteRenderer = RTCVideoRenderer();
      await remoteRenderer.initialize();
      remoteRenderer.srcObject = stream;
      if (mounted)
        setState(() => this.remoteRenderers[peerID] = remoteRenderer);
    });

    this.commManager?.onRemoveRemoteStream =
        ((peerID, _) => this.remoteRenderers[peerID]?.srcObject = null);

    this.commManager?.onCameraToggled =
        (b) => !mounted ? null : setState(() => this.isOtherCameraEnabled = b);

    this.commManager?.onMicToggled =
        (b) => !mounted ? null : setState(() => this.isOtherSoundEnabled = b);

    return await this.commManager?.connect(widget.callID);
  }

  void onCallStatusUpdate(String msg, int code) {
    setState(() {
      this.infoMsg = msg;
      this.infoCode = code;
      this.receivedCodes.add(code);
    });
    if (code == KVOIPCommManager.CODE_INCOMING_CALL)
      print("We got the incoming call signal!");
  }

  void onCallError(String msg, int code) {
    setState(() {
      this.infoMsg = msg;
      this.infoCode = code;
      // this.receivedCodes.add(code);
    });
    if (code == KVOIPCommManager.NO_PEER)
      print("We got the missing peer signal!");
  }

  /// No longer needed but not a bad idea for later so keeping it
  void genericSignalListener(SignalingState state) {
    switch (state) {
      default:
        break;
    }
  }

  void senderSignalListener(SignalingState state) {
    if (!KHostConfig.isReleaseMode) print("senderSignalListener state $state");

    switch (state) {
      case SignalingState.CallStateNew:
        {
          final p2pSession = KP2PSession.fromUser(KSessionData.me!)
            ..chatID = this.chatID
            ..refApp = this.refApp
            ..refID = this.refID;
          setState(() => this.callState = _CallState.waiting);
          this.commManager?.createRoom(p2pSession);
        }
        break;
      case SignalingState.CallStateRoomCreated:
        {
          if (this.commManager?.session != null)
            notifyWebRTCCall(this.commManager!.session!.id!);
        }
        break;
      case SignalingState.CallStateRoomEmpty:
        // safePop(false);
        setState(() => this.callState = _CallState.ended);
        break;
      case SignalingState.CallStateBye:
        if (!KHostConfig.isReleaseMode)
          print("senderSignalListener case CallStateBye");

        // TODO do we need to null out localRenderer/remoteRenderer
        // pop() will call dispose()
        setState(() => this.callState = _CallState.ended);
        Future.delayed(
          Duration(milliseconds: 500),
          () => safePop(true),
        );
        break;
      case SignalingState.CallStateInvite:
        if (!KHostConfig.isReleaseMode)
          print("senderSignalListener case CallStateInvite");

        // invitePeer(this.refPUID ?? "", false);
        break;
      case SignalingState.CallStateAccepted:
        if (!KHostConfig.isReleaseMode)
          print("senderSignalListener case CallStateAccepted");

        // stopCallerTune();
        stopRingtone();
        videoTap();
        setState(() => this.callState = _CallState.in_progress);
        break;
      case SignalingState.CallStateRejected:
        if (!KHostConfig.isReleaseMode)
          print("senderSignalListener case CallStateRejected");

        // stopCallerTune();
        stopRingtone();
        KSnackBarHelper.error("Call declined");
        setState(() {
          // this.localRenderer.srcObject = null;
          // this.remoteRenderer.srcObject = null;
          this.callState = _CallState.ended;
        });

        // should do more like fb messenger
        Future.delayed(
          Duration(milliseconds: 1500),
          () => safePop(true),
        );
        break;
      case SignalingState.ConnectionOpen:
        if (!KHostConfig.isReleaseMode)
          print("senderSignalListener case ConnectionOpen");

        // notifyWebRTCCall();
        break;
      default:
        if (!KHostConfig.isReleaseMode)
          print("senderSignalListener case default");
        break;
    }
  }

  void receiverSignalListener(SignalingState state) {
    if (!KHostConfig.isReleaseMode)
      print("receiverSignalListener state $state");

    switch (state) {
      case SignalingState.CallStateNew:
        this.commManager?.getRoomInfo(widget.callID!);
        break;
      case SignalingState.CallStateRoomInfo:
        setState(() => this.callState = _CallState.waiting);
        if (this.commManager?.session != null) {
          setState(() {
            this.chatCtrl = KChatroomController(
              chatID: this.commManager!.session!.chatID,
              refApp: this.commManager!.session!.refApp,
              refID: this.commManager!.session!.refID,
              members: [
                KChatMember.fromUser(KUser()
                  ..firstName = this.commManager!.session!.adminName
                  ..puid = this.commManager!.session!.adminPUID
                  ..avatarURL = this.commManager!.session!.adminAvatarURL),
                KChatMember.fromUser(KSessionData.me!),
              ],
            );
          });
        }
        break;
      case SignalingState.CallStateRoomEmpty:
        // safePop(false);
        stopRingtone();
        setState(() => this.callState = _CallState.ended);
        break;
      case SignalingState.CallStateBye:
        if (!KHostConfig.isReleaseMode)
          print("receiverSignalListener case CallStateBye");

        stopRingtone();
        Future.delayed(Duration(milliseconds: 3500), () => safePop(true));
        break;
      case SignalingState.CallStateAccepted:
        if (!KHostConfig.isReleaseMode)
          print("receiverSignalListener case CallStateAccepted");

        setState(() => this.callState = _CallState.in_progress);
        videoTap();
        stopRingtone();
        break;
      case SignalingState.ConnectionOpen:
        if (!KHostConfig.isReleaseMode)
          print("receiverSignalListener case ConnectionOpen");

        // this.commManager?.receiverConnected(widget.refUser.puid ?? "");
        if (!widget.autoPickup) startRingtone();

        break;
      default:
        break;
    }
  }

  void notifyWebRTCCall(String roomID) async => widget.notify?.call(
        [
          this.refPUID!,
          ...?widget.invitePUIDs,
        ],
        roomID,
        this._uuid,
        // callType: KWebRTCHelper.CATEGORY_VIDEO,
      );

  void switchCamera() => this.commManager?.switchCamera();

  void setSpeakerphone(bool enabled) =>
      this.commManager?.setSpeakerphoneEnabled(enabled);

  // void invitePeer(String peerID, bool useScreen) async {
  //   if (this.commManager != null && peerID != this.myPUID)
  //     this.commManager?.invite(this.isAudioCall ? 'audio' : 'video', useScreen);
  // }

  void timeOutCall() async {
    FlutterRingtonePlayer.stop();
    this.timer?.cancel();
    // stopCallerTune();
    KSnackBarHelper.error("Call not answered");
    try {
      this.commManager?.sayGoodbye();
    } catch (e) {}
    safePop(true);
  }

  void startRingtone([double volume = 0.9]) {
    try {
      if (Platform.isIOS) {
        this.timer = Timer.periodic(
          Duration(seconds: 3),
          (_) => FlutterRingtonePlayer.playRingtone(
            looping: true,
            volume: volume,
          ),
        );
      } else {
        FlutterRingtonePlayer.playRingtone(looping: true, volume: volume);
      }
    } catch (e) {}
  }

  void stopRingtone() {
    try {
      this.timer?.cancel();
      FlutterRingtonePlayer.stop();
    } catch (e) {}
  }

  void hangUp() {
    print("tutoring_p2p_call.hangUp am clicking hangup.........");
    this.timer?.cancel();
    FlutterRingtonePlayer.stop();
    try {
      // stopCallerTune();
      this.commManager?.sayGoodbye();
    } catch (e) {}
    safePop(true);
  }

  void videoTap() {
    if (this.panelCtrl.isAttached) {
      if (this._slidingAnimationController.status ==
          AnimationStatus.dismissed) {
        this._slidingAnimationController.forward();
      } else if (this._slidingAnimationController.status ==
          AnimationStatus.completed) {
        this._slidingAnimationController.reverse();
      }
    }
    startPanelTimeout();
  }

  void startPanelTimeout() {
    this.panelTimer?.cancel();
    this.panelTimer = Timer.periodic(
      Duration(seconds: 4),
      (_) {
        if (this.panelCtrl.isAttached &&
            this._slidingAnimationController.status ==
                AnimationStatus.completed) {
          this._slidingAnimationController.reverse();
        }
      },
    );
  }

  void answerCall() {
    // print("ANSWERING THE CALL");
    // this.commManager?.acceptCallInvite(widget.refUser?.puid ?? "");

    print("JOINING ROOM!!!");
    this.commManager?.joinRoom(widget.callID!);
  }

  void rejectCall() {
    print("tutoring_p2p_call.rejectCall am clicking hangup.........");
    this.timer?.cancel();
    FlutterRingtonePlayer.stop();
    try {
      this.commManager?.sayGoodbye();
    } catch (e) {}
    safePop(true);
  }

  void onMicToggled(bool newValue) {
    setState(() => this.isMySoundEnabled = newValue);
    this.commManager?.setMicEnabled(newValue);
  }

  void onSpeakerToggled(bool newValue) {
    setState(() => this.isMySpeakerEnabled = newValue);
    this.commManager?.setSpeakerphoneEnabled(newValue);
  }

  void onCameraToggled(bool newValue) {
    setState(() => this.isMyCameraEnabled = newValue);
    this.commManager?.setCameraEnabled(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final callView = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (this.isVideoInitialized) ...[
          KP2PVideoView(
            localRenderer: this.localRenderer!,
            remoteRenderers: this.remoteRenderers,
            isRemoteCameraEnabled: this.isOtherCameraEnabled,
            isRemoteMicEnabled: this.isOtherSoundEnabled,
            onLocalVideoTap: this.switchCamera,
            onRemoteVideoTap: this.videoTap,
          ),
        ],
        if (!this.isChatEnabled) ...[
          Positioned(
            bottom: 20.0,
            left: 10.0,
            right: 10.0,
            child: SafeArea(
              child: Container(
                width: 200.0,
                child: KP2PButtonView(
                  isMicEnabled: this.isMySoundEnabled,
                  isCameraEnabled: this.isMyCameraEnabled,
                  type: KWebRTCCallType.video,
                  onMicToggled: onMicToggled,
                  onCameraToggled: onCameraToggled,
                  isSpeakerEnabled: this.isMySpeakerEnabled,
                  onSpeakerToggled: onSpeakerToggled,
                  onHangUp: hangUp,
                ),
              ),
            ),
          )
        ],
      ],
    );

    final senderConnectButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        KP2PButton(
          onClick: hangUp,
          backgroundColor: KStyles.colorBGNo,
          icon: Icon(Icons.call_end, color: KStyles.colorButtonText),
        ),
      ],
    );

    final receiverConnectButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (!this.hasPeerError)
          KP2PButton(
            onClick: rejectCall,
            backgroundColor: KStyles.colorBGNo,
            icon: Icon(Icons.call, color: KStyles.colorButtonText),
          ),
        if (this.hasPeerError)
          KP2PButton(
            onClick: safePop,
            backgroundColor: KStyles.colorBGNo,
            icon: Icon(Icons.logout, color: KStyles.colorButtonText),
          ),
        if (!(this.isAudioCall || this.isAccepted || this.hasPeerError)) ...[
          KP2PButton(
            onClick: answerCall,
            backgroundColor: Colors.green,
            icon: Icon(Icons.videocam, color: KStyles.colorButtonText),
          ),
        ],
      ],
    );

    final callBackground = Stack(
      fit: StackFit.expand,
      children: [
        this.refAvatarURL == null && widget.videoLogo == null
            ? Icon(Icons.video_call, size: 300, color: Colors.green)
            : FadeInImage(
                placeholder: AssetImage(KAssets.IMG_TRANSPARENCY),
                image: (this.refAvatarURL == null)
                    ? Image.asset(widget.videoLogo!).image
                    : NetworkImage(this.refAvatarURL!),
                fit: BoxFit.cover,
              ),
        Container(color: KStyles.black.withOpacity(0.8)),
        SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              Container(
                width: 100,
                child: KUserAvatar(
                  imageURL: this.refAvatarURL,
                  initial: this.refName,
                ),
              ),
              SizedBox(height: 24),
              Text(
                this.refName ?? "",
                textAlign: TextAlign.center,
                style: KStyles.largeXXLText.copyWith(
                  color: KStyles.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (this.callState == _CallState.in_progress) ...[
                SizedBox(height: 24),
                Text(
                  this.infoLabel,
                  textAlign: TextAlign.center,
                  style: KStyles.normalText.copyWith(color: KStyles.lightGrey),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    final connectView = Container(
      color: KStyles.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          callBackground,
          Positioned(
            bottom: 20.0,
            left: 10.0,
            right: 10.0,
            child: SafeArea(
              child: Container(
                width: 200.0,
                child: widget.perspective == _CallPerspective.sender
                    ? senderConnectButtons
                    : receiverConnectButtons,
              ),
            ),
          ),
        ],
      ),
    );

    final endedView = Stack(
      fit: StackFit.expand,
      children: [
        callBackground,
        Center(
          child: Text(
            "Call has ended",
            style: KStyles.largeText.copyWith(color: KStyles.white),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: SafeArea(
              child: KP2PButton(
                onClick: safePop,
                backgroundColor: KStyles.colorBGNo,
                icon: Icon(Icons.logout, color: KStyles.colorButtonText),
              ),
            ),
          ),
        ),
      ],
    );

    final initView = Container(
      color: KStyles.black.withOpacity(0.8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Text(
              "Connecting to call...",
              style: KStyles.largeXLText.copyWith(color: KStyles.white),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: SafeArea(
                child: KP2PButton(
                  onClick: safePop,
                  backgroundColor: KStyles.colorBGNo,
                  icon: Icon(Icons.close, color: KStyles.colorButtonText),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final wsErrorView = Container(
      color: KStyles.black.withOpacity(0.8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Video calling service is unavailable",
                  textAlign: TextAlign.center,
                  style: KStyles.largeXLText.copyWith(color: KStyles.white),
                ),
                SizedBox(height: 16),
                Text(
                  "Please try again in a moment",
                  textAlign: TextAlign.center,
                  style: KStyles.normalText.copyWith(color: KStyles.white),
                ),
                if (!KHostConfig.isReleaseMode) ...[
                  SizedBox(height: 30),
                  Text(
                    "!! (the TURN server is likely dead/crashed/frozen) !!",
                    textAlign: TextAlign.center,
                    style:
                        KStyles.normalText.copyWith(color: KStyles.colorError),
                  ),
                ],
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: SafeArea(
                child: KP2PButton(
                  onClick: safePop,
                  backgroundColor: KStyles.colorBGNo,
                  icon: Icon(Icons.close, color: KStyles.colorButtonText),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // bool isStartedCall = false; // TODO - refactor this out of the build method

    final voipView;
    switch (this.callState) {
      case _CallState.ws_error:
        voipView = wsErrorView;
        break;
      case _CallState.init:
        // isStartedCall = widget.autoPickup;
        voipView = widget.autoPickup ? callView : initView;
        break;
      case _CallState.waiting:
        // isStartedCall = widget.autoPickup;
        voipView = widget.autoPickup ? callView : connectView;
        break;
      case _CallState.in_progress:
        // isStartedCall = true;
        voipView = callView;
        break;
      case _CallState.ended:
        voipView = endedView;
        break;
    }

    final chatroom = this.chatCtrl?.value.chatID == null
        ? Container()
        : KChatroom(this.chatCtrl!, getUsers: this.widget.getUsers);

    final body = this.callState == _CallState.in_progress && this.isChatEnabled
        ? () {
            final chatView = Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 35),
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
                KP2PButtonView(
                  isMicEnabled: this.isMySoundEnabled,
                  isCameraEnabled: this.isMyCameraEnabled,
                  type: KWebRTCCallType.video,
                  onMicToggled: onMicToggled,
                  onCameraToggled: onCameraToggled,
                  isSpeakerEnabled: this.isMySpeakerEnabled,
                  onSpeakerToggled: onSpeakerToggled,
                  onHangUp: hangUp,
                ),
                SizedBox(height: 28),
                Expanded(
                    child: Container(
                  child: chatroom,
                  color: Colors.white,
                )),
              ],
            );

            final viewInsets = EdgeInsets.fromWindowPadding(
              WidgetsBinding.instance!.window.viewInsets,
              WidgetsBinding.instance!.window.devicePixelRatio,
            );
            final screenHeight = MediaQuery.of(context).size.height * 0.8;
            final maxHeight = screenHeight - viewInsets.bottom.toDouble();
            final slidingBody = SlidingUpPanel(
              color: Colors.transparent,
              onPanelClosed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                this.startPanelTimeout();
              },
              onPanelOpened: () {
                this.panelTimer?.cancel();
              },
              border: Border.all(color: Colors.white),
              backdropEnabled: false,
              boxShadow: null,
              controller: this.panelCtrl,
              minHeight: 150,
              maxHeight: maxHeight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              // parallaxEnabled: true,
              body: Container(),
              panel: chatView,
            );

            return Stack(
              children: [
                voipView,
                SlideTransition(
                  position: this._slidingAnimation,
                  child: slidingBody,
                ),
              ],
            );
          }()
        : voipView;

    return Scaffold(
      // body: Stack(
      //   children: [
      //     body,
      //     Align(
      //       alignment: Alignment.topLeft,
      //       child: SafeArea(child: BackButton(onPressed: safePop)),
      //     ),
      //   ],
      // ),
      body: body,
    );
  }
}
