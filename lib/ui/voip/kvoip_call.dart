import 'dart:async';
import 'dart:io';

import 'package:app_core/header/kassets.dart';
import 'package:app_core/helper/service/kvoip_service.dart';
import 'package:app_core/ui/voip/kvoip_context.dart';
import 'package:app_core/ui/widget/dialog/boolean_dialog.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:app_core/helper/kcall_kit_helper.dart';
import 'package:app_core/helper/knotif_stream_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/helper/ksnackbar_helper.dart';
import 'package:app_core/helper/kwebrtc_helper.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:app_core/ui/voip/kvoip_comm_manager.dart';
import 'package:app_core/ui/voip/widget/kp2p_button_view.dart';
import 'package:app_core/ui/voip/widget/kp2p_video_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uuid/uuid.dart';
import 'package:app_core/app_core.dart';
import 'package:wakelock/wakelock.dart';

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

  KVOIPCall({
    required this.perspective,
    this.refUser,
    this.invitePUIDs,
    this.callID,
    this.uuid,
    this.autoPickup = false,
    this.chatroomCtrl,
    this.videoLogo,
  });

  KVOIPCall.asSender(
    KUser refUser, {
    List<String>? invitePUIDs,
    this.chatroomCtrl,
    String? videoLogo,
  })  : this.refUser = refUser,
        this.invitePUIDs = invitePUIDs,
        this.perspective = _CallPerspective.sender,
        this.autoPickup = false,
        this.uuid = Uuid().v4(),
        this.callID = null,
        this.videoLogo = videoLogo;

  KVOIPCall.asReceiver(String callID, String uuid,
      {this.autoPickup = false, this.videoLogo, this.chatroomCtrl})
      : this.refUser = null,
        this.invitePUIDs = null,
        this.perspective = _CallPerspective.receiver,
        this.callID = callID,
        this.uuid = uuid;

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

  // final Map<String, RTCVideoRenderer> remoteRenderers = {};

  late KChatroomController? chatCtrl =
      widget.chatroomCtrl == null ? null : widget.chatroomCtrl!;
  late _CallState callState = widget.perspective == _CallPerspective.sender
      ? _CallState.waiting
      : _CallState.init;

  KVoipContext? voipContext;
  Timer? ringtoneTimer;
  Timer? endCallTimer;
  Timer? panelTimer;
  String? infoMsg;
  int? infoCode;

  // RTCVideoRenderer? localRenderer;
  bool isMySoundEnabled = true;
  bool isMySpeakerEnabled = true;
  bool isMyCameraEnabled = true;
  bool isOtherSoundEnabled = true;
  bool isOtherCameraEnabled = true;
  bool isPanelOpen = false;

  String get voipServiceID {
    final id = widget.callID ?? "anonymous call";
    print("VOIP SERVICE ID - $id");
    return id;
  }

  KVOIPCommManager? get commManager => voipContext?.commManager;

  RTCVideoRenderer? get localRenderer => voipContext?.localRenderer;

  Map<String, RTCVideoRenderer>? get remoteRenderers =>
      voipContext?.remoteRenderers;

  bool get isAccepted => widget.autoPickup;

  String get _uuid => widget.uuid ?? Uuid().v4();

  bool get isAudioCall => false;

  bool get isChatEnabled => chatCtrl != null;

  String? get chatID =>
      widget.chatroomCtrl?.value.chatID ?? commManager?.session?.chatID;

  String? get refApp =>
      widget.chatroomCtrl?.value.refApp ?? commManager?.session?.refApp;

  String? get refID =>
      widget.chatroomCtrl?.value.refID ?? commManager?.session?.refID;

  String? get refAvatarURL => widget.perspective == _CallPerspective.sender
      ? widget.refUser?.avatarURL
      : commManager?.session?.adminAvatarURL;

  String? get refName => widget.perspective == _CallPerspective.sender
      ? widget.refUser?.fullName
      : commManager?.session?.adminName;

  String? get myPUID => KSessionData.me?.puid;

  String? get myName => KSessionData.me?.firstName;

  String? get refPUID => widget.refUser?.puid;

  String get infoLabel {
    if (hasPeerError) {
      final refName = widget.refUser?.firstName ?? "The other person";
      return "$refName left the call";
    } else {
      final prefix = KHostConfig.isReleaseMode ? "" : "[${infoCode}] ";
      return KStringHelper.isEmpty(infoMsg) ? "" : "$prefix${infoMsg}...";
    }
  }

  bool get isReceiverReadyToPickup =>
      receivedCodes.contains(KVOIPCommManager.CODE_INCOMING_CALL);

  bool get hasPeerError => receivedCodes.contains(KVOIPCommManager.NO_PEER);

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    KCallKitHelper.instance.isCalling = true;
    WidgetsBinding.instance?.addObserver(this);

    _slidingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..forward();
    _slidingAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _slidingAnimationController,
      curve: Curves.easeInOut,
    ));

    streamSub = KNotifStreamHelper.stream.listen(notifListener);

    // White status bar icons & black software buttons
    SystemChrome.setSystemUIOverlayStyle(KStyles.systemStyle.copyWith(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: KStyles.black,
    ));

    requestPermission().whenComplete(setupVoipContext).whenComplete(() {
      if (widget.autoPickup) answerCall();
    });
  }

  @override
  void dispose() {
    if (!KHostConfig.isReleaseMode) print("P2PCall.dispose fired...");
    _slidingAnimationController.dispose();

    Wakelock.disable();
    WidgetsBinding.instance?.removeObserver(this);

    stopRingtone();

    SystemChrome.setSystemUIOverlayStyle(KStyles.systemStyle);
    ringtoneTimer?.cancel();
    endCallTimer?.cancel();
    panelTimer?.cancel();
    streamSub.cancel();
    // releaseResourceIfNeed();
    KCallKitHelper.instance.isCalling = false;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused)
      commManager?.onPauseState();
    else if (state == AppLifecycleState.resumed) commManager?.onResumedState();
  }

  Future<void> setupVoipContext() async {
    // CHECK FOR EXISTING VOIP CONTEXT
    if (KVoipService.hasContext(voipServiceID)) {
      print("###### KVoipService EXISTING CONTEXT ID - $voipServiceID");
      voipContext = KVoipService.getContext(voipServiceID);
      setState(() => callState = _CallState.in_progress);
      return;
    } else {
      print("###### KVoipService !! NO !! CONTEXT ID - $voipServiceID");
      voipContext = KVoipContext();
    }

    // INIT RENDERS
    final localRendererResult = await buildLocalRenderer();
    if (localRendererResult == null) {
      safePop();
      return;
    } else {
      setState(() {
        voipContext!.localRenderer = localRendererResult;
      });
    }

    // SETUP COMM MANAGER
    final commManagerResult = await buildCommManager(myPUID!, myName!);
    if (commManagerResult == null) {
      KSnackBarHelper.error("Websocket connection failed");
      safePop();
      return;
    } else {
      setState(() {
        voipContext!.commManager = commManagerResult;
      });
    }

    KVoipService.addContext(voipServiceID, voipContext!);
  }

  Future<RTCVideoRenderer?> buildLocalRenderer() async {
    final permissionsGranted = await KWebRTCHelper.askForPermissions();
    if (permissionsGranted) {
      final renderer = RTCVideoRenderer();
      await renderer.initialize();
      return renderer;
    } else {
      print("SAFE POP because permissions not granted");
      // safePop();
      return null;
    }
  }

  void releaseResourceIfNeed() {
    if (commManager != null && !commManager!.isDisposed) {
      commManager?.close();
      localRenderer?.dispose();
      remoteRenderers?.forEach((_, rr) => rr.dispose());
      KCallKitHelper.instance.endCall(_uuid, "", "", "");
    }
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
        //     notification.data?.otherId != commManager?.session?.id;

        // If this call has already ended, respond to incoming call
        if (notification.data?.id != null && callState == _CallState.ended) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => KVOIPCall.asReceiver(
                  notification.data!.id!, notification.data!.uuid!,
                  autoPickup: true, videoLogo: widget.videoLogo)));

          // safePop();
          // KWebRTCHelper.displayCallScreen(notification.data!.id!);
        }
        break;
    }
  }

  void safePop([final result]) {
    if (mounted && (ModalRoute.of(context)?.isActive ?? false)) {
      Navigator.of(context).pop(result);
    }
  }

  Future<KVOIPCommManager?> buildCommManager(String puid, String name) async {
    KVOIPCommManager? commManager;
    try {
      commManager = KVOIPCommManager(
        puid: puid,
        deviceID: await KUtil.getDeviceID(),
        nickname: name,
      );
    } catch (e) {
      return null;
    }

    commManager.onStateChange = (SignalingState ss) {
      genericSignalListener(ss);
      Function.apply(
        widget.perspective == _CallPerspective.sender
            ? senderSignalListener
            : receiverSignalListener,
        [ss],
      );
    };

    commManager.onCallInfo = onCallStatusUpdate;
    commManager.onCallError = onCallError;

    commManager.onLocalStream =
        ((peerID, stream) => setState(() => localRenderer?.srcObject = stream));

    commManager.onAddRemoteStream = ((peerID, stream) async {
      final remoteRenderer = RTCVideoRenderer();
      await remoteRenderer.initialize();
      remoteRenderer.srcObject = stream;
      if (mounted) setState(() => remoteRenderers?[peerID] = remoteRenderer);
    });

    commManager.onRemoveRemoteStream =
        ((peerID, _) => remoteRenderers?[peerID]?.srcObject = null);

    commManager.onCameraToggled =
        (b) => !mounted ? null : setState(() => isOtherCameraEnabled = b);

    commManager.onMicToggled =
        (b) => !mounted ? null : setState(() => isOtherSoundEnabled = b);

    await commManager.connect(widget.callID);
    return commManager;
  }

  void onCallStatusUpdate(String msg, int code) {
    setState(() {
      infoMsg = msg;
      infoCode = code;
      receivedCodes.add(code);
    });
    if (code == KVOIPCommManager.CODE_INCOMING_CALL)
      print("We got the incoming call signal!");
  }

  void onCallError(String msg, int code) {
    setState(() {
      infoMsg = msg;
      infoCode = code;
      // receivedCodes.add(code);
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
            ..chatID = chatID
            ..refApp = refApp
            ..refID = refID;
          setState(() => callState = _CallState.waiting);
          commManager?.createRoom(p2pSession);
        }
        break;
      case SignalingState.CallStateRoomCreated:
        {
          if (commManager?.session != null)
            notifyWebRTCCall(commManager!.session!.id!);
        }
        break;
      case SignalingState.CallStateRoomEmpty:
        // safePop(false);
        setState(() => callState = _CallState.ended);
        endCallTimeout();
        releaseResourceIfNeed();
        break;
      case SignalingState.CallStateBye:
        if (!KHostConfig.isReleaseMode)
          print("senderSignalListener case CallStateBye");

        // TODO do we need to null out localRenderer/remoteRenderer
        // pop() will call dispose()
        setState(() => callState = _CallState.ended);
        releaseResourceIfNeed();
        endCallTimeout();
        Future.delayed(
          Duration(milliseconds: 500),
          () => safePop(true),
        );
        break;
      case SignalingState.CallStateInvite:
        if (!KHostConfig.isReleaseMode)
          print("senderSignalListener case CallStateInvite");

        // invitePeer(refPUID ?? "", false);
        break;
      case SignalingState.CallStateAccepted:
        if (!KHostConfig.isReleaseMode)
          print("senderSignalListener case CallStateAccepted");

        // stopCallerTune();
        stopRingtone();
        startPanelTimeout(6);
        setState(() => callState = _CallState.in_progress);
        break;
      case SignalingState.CallStateRejected:
        if (!KHostConfig.isReleaseMode)
          print("senderSignalListener case CallStateRejected");

        // stopCallerTune();
        stopRingtone();
        KSnackBarHelper.error("Call declined");
        setState(() {
          // localRenderer.srcObject = null;
          // remoteRenderer.srcObject = null;
          callState = _CallState.ended;
        });
        releaseResourceIfNeed();
        endCallTimeout();
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
        commManager?.getRoomInfo(widget.callID!);
        break;
      case SignalingState.CallStateRoomInfo:
        setState(() => callState = _CallState.waiting);
        if (commManager?.session != null) {
          setState(() {
            chatCtrl = KChatroomController(
              chatID: commManager!.session!.chatID,
              refApp: commManager!.session!.refApp,
              refID: commManager!.session!.refID,
              members: [
                KChatMember.fromUser(KUser()
                  ..firstName = commManager!.session!.adminName
                  ..puid = commManager!.session!.adminPUID
                  ..avatarURL = commManager!.session!.adminAvatarURL),
                KChatMember.fromUser(KSessionData.me!),
              ],
            );
          });
        }
        break;
      case SignalingState.CallStateRoomEmpty:
        // safePop(false);
        stopRingtone();
        setState(() => callState = _CallState.ended);
        releaseResourceIfNeed();
        endCallTimeout();
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

        setState(() => callState = _CallState.in_progress);
        startPanelTimeout(6);
        stopRingtone();
        break;
      case SignalingState.ConnectionOpen:
        if (!KHostConfig.isReleaseMode)
          print("receiverSignalListener case ConnectionOpen");

        // commManager?.receiverConnected(widget.refUser.puid ?? "");
        if (!widget.autoPickup) startRingtone();

        break;
      default:
        break;
    }
  }

  void notifyWebRTCCall(String roomID) async => KServerHandler.notifyWebRTCCall(
        refPUIDs: [
          refPUID!,
          ...?widget.invitePUIDs,
        ],
        callID: roomID,
        uuid: _uuid,
        // callType: WebRTCHelper.CATEGORY_VIDEO,
      );

  void switchCamera() => commManager?.switchCamera();

  void setSpeakerphone(bool enabled) =>
      commManager?.setSpeakerphoneEnabled(enabled);

  // void invitePeer(String peerID, bool useScreen) async {
  //   if (commManager != null && peerID != myPUID)
  //     commManager?.invite(isAudioCall ? 'audio' : 'video', useScreen);
  // }

  void endCallTimeout() async {
    endCallTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      safePop(true);
    });
  }

  void startRingtone([double volume = 0.9]) {
    try {
      if (Platform.isIOS) {
        ringtoneTimer = Timer.periodic(
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
      ringtoneTimer?.cancel();
      FlutterRingtonePlayer.stop();
    } catch (e) {}
  }

  void hangUp() {
    print("tutoring_p2p_call.hangUp am clicking hangup.........");
    ringtoneTimer?.cancel();
    FlutterRingtonePlayer.stop();
    try {
      // stopCallerTune();
      commManager?.sayGoodbye();
    } catch (e) {}
    KVoipService.removeContext(voipServiceID);
    safePop(true);
  }

  void videoTap() {
    if (panelCtrl.isAttached) {
      if (_slidingAnimationController.status == AnimationStatus.dismissed) {
        _slidingAnimationController.forward();
      } else if (_slidingAnimationController.status ==
          AnimationStatus.completed) {
        _slidingAnimationController.reverse();
      }
    }
    startPanelTimeout();
  }

  void startPanelTimeout([int seconds = 4]) {
    panelTimer?.cancel();
    panelTimer = Timer.periodic(
      Duration(seconds: seconds),
      (_) {
        if (panelCtrl.isAttached &&
            _slidingAnimationController.status == AnimationStatus.completed) {
          _slidingAnimationController.reverse();
        }
      },
    );
  }

  void answerCall() {
    // print("ANSWERING THE CALL");
    // commManager?.acceptCallInvite(widget.refUser?.puid ?? "");

    print("JOINING ROOM!!!");
    commManager?.joinRoom(widget.callID!);
  }

  void rejectCall() {
    print("tutoring_p2p_call.rejectCall am clicking hangup.........");
    ringtoneTimer?.cancel();
    FlutterRingtonePlayer.stop();
    try {
      commManager?.sayGoodbye();
    } catch (e) {}
    safePop(true);
  }

  void onMicToggled(bool newValue) {
    setState(() => isMySoundEnabled = newValue);
    commManager?.setMicEnabled(newValue);
  }

  void onSpeakerToggled(bool newValue) {
    setState(() => isMySpeakerEnabled = newValue);
    commManager?.setSpeakerphoneEnabled(newValue);
  }

  void onCameraToggled(bool newValue) {
    setState(() => isMyCameraEnabled = newValue);
    commManager?.setCameraEnabled(newValue);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (_) =>
              BooleanDialog(title: 'Cúp máy?', isPositiveTheme: false),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final callView = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (localRenderer != null) ...[
          KP2PVideoView(
            localRenderer: localRenderer!,
            remoteRenderers: remoteRenderers!,
            isRemoteCameraEnabled: isOtherCameraEnabled,
            isRemoteMicEnabled: isOtherSoundEnabled,
            onLocalVideoTap: switchCamera,
            onRemoteVideoTap: videoTap,
          ),
        ],
        if (!isChatEnabled) ...[
          Positioned(
            bottom: 20.0,
            left: 10.0,
            right: 10.0,
            child: SafeArea(
              child: Container(
                width: 200.0,
                child: KP2PButtonView(
                  isMicEnabled: isMySoundEnabled,
                  isCameraEnabled: isMyCameraEnabled,
                  type: KWebRTCCallType.video,
                  onMicToggled: onMicToggled,
                  onCameraToggled: onCameraToggled,
                  isSpeakerEnabled: isMySpeakerEnabled,
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
        if (!hasPeerError)
          KP2PButton(
            onClick: rejectCall,
            backgroundColor: KStyles.colorBGNo,
            icon: Icon(Icons.call, color: KStyles.colorButtonText),
          ),
        if (hasPeerError)
          KP2PButton(
            onClick: safePop,
            backgroundColor: KStyles.colorBGNo,
            icon: Icon(Icons.logout, color: KStyles.colorButtonText),
          ),
        if (!(isAudioCall || isAccepted || hasPeerError)) ...[
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
        refAvatarURL == null && widget.videoLogo == null
            ? Icon(Icons.video_call, size: 300, color: Colors.green)
            : FadeInImage(
                placeholder: AssetImage(KAssets.IMG_TRANSPARENCY),
                image: (refAvatarURL == null)
                    ? Image.asset(widget.videoLogo!).image
                    : NetworkImage(refAvatarURL!),
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
                  imageURL: refAvatarURL,
                  initial: refName,
                ),
              ),
              SizedBox(height: 24),
              Text(
                refName ?? "",
                textAlign: TextAlign.center,
                style: KStyles.largeXXLText.copyWith(
                  color: KStyles.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (callState == _CallState.in_progress) ...[
                SizedBox(height: 24),
                Text(
                  infoLabel,
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

    final voipView;
    switch (callState) {
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

    final chatroom = chatCtrl == null ? Container() : KChatroom(chatCtrl!);

    final body = callState == _CallState.in_progress && isChatEnabled
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
                  isMicEnabled: isMySoundEnabled,
                  isCameraEnabled: isMyCameraEnabled,
                  type: KWebRTCCallType.video,
                  onMicToggled: onMicToggled,
                  onCameraToggled: onCameraToggled,
                  isSpeakerEnabled: isMySpeakerEnabled,
                  onSpeakerToggled: onSpeakerToggled,
                  onHangUp: hangUp,
                ),
                SizedBox(height: 28),
                Expanded(child: Container(child: chatroom)),
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
                startPanelTimeout();
              },
              onPanelOpened: () {
                panelTimer?.cancel();
              },
              border: Border.all(color: Colors.white),
              backdropEnabled: false,
              boxShadow: null,
              controller: panelCtrl,
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
                  position: _slidingAnimation,
                  child: slidingBody,
                ),
              ],
            );
          }()
        : voipView;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
      ),
    );
  }
}
