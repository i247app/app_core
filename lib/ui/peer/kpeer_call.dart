import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:app_core/app_core.dart';
import 'package:app_core/header/kaction.dart';
import 'package:app_core/helper/kpeer_socket_helper.dart';
import 'package:app_core/helper/kpeer_webrtc_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kobject.dart';
import 'package:app_core/model/kremote_peer.dart';
import 'package:app_core/model/kwebrtc_conference.dart';
import 'package:app_core/model/kwebrtc_member.dart';
import 'package:app_core/ui/peer/widget/kpeer_button_view.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:queue/queue.dart';

class KPeerCall extends StatefulWidget {
  const KPeerCall({
    Key? key,
  }) : super(key: key);

  @override
  State<KPeerCall> createState() => _KPeerCallState();
}

class _KPeerCallState extends State<KPeerCall> {
  final Queue queue = Queue();
  StreamSubscription? connectionStatusStreamSubscription;
  StreamSubscription? dataStreamSubscription;
  StreamSubscription? localPlayerStreamSubscription;
  StreamSubscription? remotePlayerStreamSubscription;

  final _localRenderer = RTCVideoRenderer();
  List<Map<String, dynamic>> _remoteRenderers = [];

  bool isFetchingMeeting = false;
  bool isCallSetting = false;
  bool inCall = false;
  bool isCalled = false;
  String? errorMsg;

  List<KWebRTCConference> meetingList = [];
  KWebRTCConference? currentMeeting;

  KWebRTCMember? get currentMeetingMember =>
      currentMeeting?.webRTCMembers?.firstWhere((webRTCMember) =>
          webRTCMember.puid == KSessionData.me?.puid &&
          KSessionData.me?.puid != null);

  int get peerCount =>
      (_localRenderer.srcObject != null ? 1 : 0) +
      _remoteRenderers
          .where((e) => e['remoteRenderer']?.srcObject != null)
          .length;

  bool isMySoundEnabled = true;
  bool isMySpeakerEnabled = true;
  bool isMyCameraEnabled = true;
  bool isBringMyCamBack = false;
  bool isPanelOpen = false;

  @override
  void initState() {
    super.initState();

    fetchMeeting();
  }

  @override
  void dispose() {
    KPeerWebRTCHelper.dispose();
    connectionStatusStreamSubscription?.cancel();
    dataStreamSubscription?.cancel();
    localPlayerStreamSubscription?.cancel();
    remotePlayerStreamSubscription?.cancel();
    queue.dispose();
    KPeerSocketHelper.dispose();
    super.dispose();
  }

  void fetchMeeting() async {
    if (isFetchingMeeting) return;

    setState(() {
      isFetchingMeeting = true;
    });

    try {
      final response = await KServerHandler.webRTCConferenceAction(
          kWebRTCConference: KWebRTCConference()..kaction = KAction.LIST);
      if (response.isSuccess) {
        setState(() {
          meetingList = (response.webRTCConferences ?? [])
              .where((webRTCConference) =>
                  (KStringHelper.isExist(webRTCConference.refApp) &&
                      KStringHelper.isExist(webRTCConference.refID)) ||
                  (KStringHelper.isExist(webRTCConference.conferenceCode) &&
                      KStringHelper.isExist(webRTCConference.conferencePass)))
              .toList();
        });
      }
    } catch (ex) {}

    setState(() {
      isFetchingMeeting = false;
    });
  }

  void handleConnectionStatusUpdate(KPeerWebRTCStatus status) {
    if (mounted) {
      if (status == KPeerWebRTCStatus.CONNECTION && isCallSetting) {
        setState(() {
          isCallSetting = false;
          isCalled = true;
        });
      } else if (status == KPeerWebRTCStatus.CONNECTED) {
        setState(() {
          inCall = true;
        });
      }
    }
  }

  void handleLocalPlayerUpdate(mediaStream) async {
    if (mounted) {
      print('handleLocalPlayerUpdate');
      await _localRenderer.initialize();
      _localRenderer.srcObject = mediaStream;
    }
  }

  Future handleRemotePlayerUpdate(Map<String, dynamic> remotePeer) async {
    print('handleRemotePlayerUpdate ${new DateTime.now().toIso8601String()}');
    if (mounted) {
      final remotePeerId = remotePeer['peerID'];

      final index =
          _remoteRenderers.indexWhere((e) => e['peerID'] == remotePeerId);

      print(
          'remotePeer ${index} ${remotePeer} ${_remoteRenderers.map(((item) => item['peerID']))}');
      if (index == -1) {
        final _remotePeer = {
          ...remotePeer,
          'remoteRenderer': null,
          'metadata': {
            'isAudioEnable': false,
            'isVideoEnable': false,
            'displayName': '',
          }
        };
        if (remotePeer['stream'] != null) {
          final _remoteRenderer = RTCVideoRenderer();
          await _remoteRenderer.initialize();
          _remoteRenderer.srcObject = remotePeer['stream'];
          _remotePeer['remoteRenderer'] = _remoteRenderer;
        }

        _remoteRenderers.add(_remotePeer);
        this.setState(() {});
      } else {
        final _remotePeer = {
          ...remotePeer,
          'remoteRenderer': null,
          'metadata': {
            'isAudioEnable': false,
            'isVideoEnable': false,
            'displayName': '',
          }
        };
        if (remotePeer['stream'] != null) {
          final _remoteRenderer = RTCVideoRenderer();
          await _remoteRenderer.initialize();
          _remoteRenderer.srcObject = remotePeer['stream'];
          _remotePeer['remoteRenderer'] = _remoteRenderer;
        }

        _remoteRenderers[index] = _remotePeer;
        this.setState(() {});
      }

      sendMetadata();
      KPeerSocketHelper.socket?.emit('retrieve-metadata', [
        this.currentMeeting?.conferenceID,
        this.currentMeetingMember?.memberKey,
      ]);
      // calculateMaxVideoEachRow();
    }
  }

  void sendMetadata() {
    KPeerSocketHelper.socket?.emit('send-data-to-room', [
      this.currentMeeting?.conferenceID,
      this.currentMeetingMember?.memberKey,
      {
        'isAudioEnable': isMySoundEnabled,
        'isVideoEnable': isMyCameraEnabled,
        'displayName': KPeerWebRTCHelper.localDisplayName,
      },
    ]);
  }

  void sendDataPacket(
    List<KRemotePeer> remotePeers,
    String type,
    Map<String, dynamic> payload,
  ) async {
    Map<String, dynamic> packet = {
      'type': type,
      'payload': payload,
    };

    remotePeers.forEach((remotePeer) {
      final conn = KPeerWebRTCHelper.remotePeers
          .firstWhereOrNull((e) => e.peerID == remotePeer.peerID)
          ?.dataConnection;
      if (conn != null && conn.open) {
        conn.sendBinary(Uint8List.fromList(jsonEncode(packet).codeUnits));
      }
    });
  }

  void handleDataUpdate(List<dynamic> data) {
    if (mounted) {
      print('handleDataUpdate');
      print(data);
      final _peerId = data[0];
      final _metadata = data[1];

      if (_peerId != this.currentMeetingMember?.memberKey) {
        final index =
            _remoteRenderers.indexWhere((e) => e['peerID'] == _peerId);
        if (index > -1 && _metadata != null) {
          this.setState(() {
            _remoteRenderers[index]['metadata'] = _metadata;
            print('_metadata ${_metadata}');
          });
        }
      }
    }
  }

  void handleWebRTCDataUpdate(Map<String, dynamic> data) {
    if (mounted) {
      print('handleWebRTCDataUpdate');
      print(data);
      final remotePeer = data['remotePeer'];
      final remotePeerData = data['data'];
      print('data ${remotePeer} ${remotePeerData}');

      switch (remotePeerData['type']) {
        // case KPeerWebRTCHelper.PACKET_TYPE_METADATA:
        //   {
        //     final index = _remoteRenderers.indexWhere(
        //         (e) => e['peerID'] == remotePeerData['payload']['peerID']);
        //     if (index > -1 && data['payload']['metadata'] != null) {
        //       _remoteRenderers[index]['metadata'] = data['payload']['metadata'];
        //     } else {
        //       // retry set metadata
        //       Future.delayed(
        //           Duration(milliseconds: 250), () => handleDataUpdate(data));
        //     }
        //   }
        //   break;
        // case KPeerWebRTCHelper.PACKET_TYPE_RETRIEVE_METADATA:
        //   {
        //     final index = _remoteRenderers.indexWhere(
        //         (e) => e['peerID'] == remotePeerData['payload']['peerID']);
        //     if (index > -1 &&
        //         _remoteRenderers[index]['peer']['dataConnection'] != null) {
        //       sendMetadata();
        //     } else {
        //       // retry set metadata
        //       Future.delayed(
        //           Duration(milliseconds: 250), () => handleDataUpdate(data));
        //     }
        //   }
        //   break;
        default:
          print('Unrecognized data packet of type ${remotePeerData['type']}');
          break;
      }
    }
  }

  Future handleJoinWithCode(
      String conferenceCode, String conferencePass) async {
    try {
      await setupCall(KWebRTCConference()
        ..conferenceCode = conferenceCode
        ..conferencePass = conferencePass);
    } catch (ex) {}
  }

  Future setupCall(KWebRTCConference meeting) async {
    setState(() {
      isCallSetting = true;
    });

    try {
      final joinResponse = await KServerHandler.webRTCConferenceAction(
          kWebRTCConference: KWebRTCConference()
            ..kaction = KAction.JOIN
            ..refID = meeting.refID
            ..refApp = meeting.refApp
            ..puid = KSessionData.me?.puid
            ..conferenceID = meeting.conferenceID
            ..conferenceKey = meeting.conferenceKey
            ..conferenceCode = meeting.conferenceCode
            ..conferencePass = meeting.conferencePass);

      if (joinResponse.isSuccess &&
          (joinResponse.webRTCConferences?.isNotEmpty ?? false)) {
        this.setState(() {
          currentMeeting = joinResponse.webRTCConferences?.first;
        });

        connectionStatusStreamSubscription = KPeerWebRTCHelper
            .connectionStatusStream
            .listen(handleConnectionStatusUpdate);
        dataStreamSubscription =
            KPeerWebRTCHelper.dataStream.listen(handleWebRTCDataUpdate);
        localPlayerStreamSubscription =
            KPeerWebRTCHelper.localPlayerStream.listen(handleLocalPlayerUpdate);
        remotePlayerStreamSubscription = KPeerWebRTCHelper.remotePlayerStream
            .listen((data) async =>
                await queue.add(() => handleRemotePlayerUpdate(data)));

        final _localStream = await KPeerWebRTCHelper.retrieveLocalStream();
        print("_localStream, ${_localStream.id}");
        await KPeerWebRTCHelper.init(
          _localStream,
          localPeerID: this.currentMeetingMember?.memberKey,
          auto: false,
          displayName: KSessionData.me?.fullName,
        );
        setupSocket();

        // Initiate call using sendCall function
        final remotePeers = currentMeeting?.webRTCMembers ?? [];
        if (remotePeers.length > 0) {
          KPeerWebRTCHelper.sendMultipleCalls(remotePeers
              .where((remotePeer) =>
                  remotePeer.memberKey != this.currentMeetingMember?.memberKey)
              .map((remotePeer) => remotePeer.memberKey));
        }
        setState(() {
          isCallSetting = false;
          isCalled = true;
        });
      } else {
        setState(() {
          isCallSetting = false;
        });
      }
    } catch (ex) {
      print("ex ${ex}");
      setState(() {
        isCallSetting = false;
      });
    }
  }

  Future setupSocket() async {
    print('setupSocket');
    dataStreamSubscription =
        KPeerSocketHelper.dataStream.listen(handleDataUpdate);

    try {
      await KPeerSocketHelper.init(
        this.currentMeeting?.conferenceID,
        this.currentMeetingMember?.memberKey,
      );

      KPeerSocketHelper.socket!.on('user-joined', (data) => sendMetadata());
    } catch (ex) {
      print('Socket error ${ex}');
    }
  }

  void safePop([final result]) {
    Navigator.of(context).pop(result);
  }

  void hangUp() {
    try {
      // stopCallerTune();
      // this.commManager?.sayGoodbye();
    } catch (e) {}
    safePop(true);
  }

  Future<bool> _onWillPop() async {
    if (currentMeeting == null) return true;

    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Hang up call?'),
            content: new Text('Cúp máy?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: hangUp,
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void onMicToggled(value) {
    setState(() {
      isMySoundEnabled = value;
    });

    final audioTrack = _localRenderer.srcObject?.getAudioTracks().first;
    if (audioTrack == null) return;

    audioTrack.enabled = value;
    sendMetadata();
  }

  void onCameraToggled(value) {
    setState(() {
      isMyCameraEnabled = value;
    });

    final videoTrack = _localRenderer.srcObject?.getVideoTracks().first;
    if (videoTrack == null) return;

    videoTrack.enabled = value;
    sendMetadata();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final callView = SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  if (_localRenderer.srcObject != null) ...[
                    _KPeerCallVideoRender(
                      videoRenderer: _localRenderer,
                      containerHeight: deviceHeight,
                      containerWidth: deviceWidth,
                      peerCount: peerCount,
                      isAudioEnable: isMySoundEnabled,
                      isVideoEnable: isMyCameraEnabled,
                      displayName: KSessionData.me?.fullName ?? '',
                      isLocal: true,
                    ),
                  ],
                  if (_remoteRenderers.length > 0)
                    ...List.generate(_remoteRenderers.length, (index) {
                      final metadata = _remoteRenderers[index]['metadata'];
                      final _remoteRenderer =
                          _remoteRenderers[index]['remoteRenderer'];
                      print(metadata);
                      if (_remoteRenderer?.srcObject != null) {
                        return _KPeerCallVideoRender(
                          videoRenderer: _remoteRenderer,
                          containerHeight: deviceHeight,
                          containerWidth: deviceWidth,
                          peerCount: peerCount,
                          isAudioEnable: metadata['isAudioEnable'],
                          isVideoEnable: metadata['isVideoEnable'],
                          displayName: metadata['displayName'] ?? '',
                          isLocal: false,
                        );
                      }
                      return Container();
                    }).toList(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 10.0,
            right: 10.0,
            child: Container(
              width: 200.0,
              child: KPeerButtonView(
                isMicEnabled: this.isMySoundEnabled,
                isCameraEnabled: this.isMyCameraEnabled,
                type: KWebRTCCallType.video,
                onMicToggled: onMicToggled,
                onCameraToggled: onCameraToggled,
                onHangUp: hangUp,
              ),
            ),
          ),
        ],
      ),
    );
    // Stack(
    //   fit: StackFit.expand,
    //   children: <Widget>[
    //     ,
    //     Positioned(
    //       bottom: 20.0,
    //       left: 10.0,
    //       right: 10.0,
    //       child: SafeArea(
    //         child: Container(
    //           width: 200.0,
    //           child: KPeerButtonView(
    //             isMicEnabled: this.isMySoundEnabled,
    //             isCameraEnabled: this.isMyCameraEnabled,
    //             type: KWebRTCCallType.video,
    //             onMicToggled: onMicToggled,
    //             onCameraToggled: onCameraToggled,
    //             onHangUp: hangUp,
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );

    final endCallButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        KP2PButton(
          onClick: hangUp,
          backgroundColor: KStyles.colorBGNo,
          icon: Icon(Icons.call_end, color: KStyles.colorButtonText),
        ),
      ],
    );

    final callBackground = Stack(
      fit: StackFit.expand,
      children: [
        Icon(Icons.video_call, size: 300, color: Colors.green),
        Container(color: KStyles.black.withOpacity(0.8)),
        SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              Container(
                width: 100,
                child: KUserAvatar.fromUser(KSessionData.me),
              ),
              SizedBox(height: 24),
              Text(
                "Connecting...",
                textAlign: TextAlign.center,
                style: KStyles.normalText.copyWith(color: KStyles.lightGrey),
              ),
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
                child: endCallButtons,
              ),
            ),
          ),
        ],
      ),
    );

    final initView = Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      color: KStyles.black.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isFetchingMeeting)
            Center(
              child: CircularProgressIndicator(),
            )
          else ...[
            if (meetingList.length > 0)
              ...List.generate(meetingList.length, (index) {
                final meeting = meetingList[index];

                if (KStringHelper.isExist(meeting.meetingName)) {
                  return ElevatedButton(
                    onPressed: isCallSetting ? null : () => setupCall(meeting),
                    style: KStyles.roundedButton(
                      Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                    ),
                    child: isCallSetting
                        ? CircularProgressIndicator()
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text(
                              "Join Call ${meeting.meetingName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                            ),
                          ),
                  );
                }

                return Container();
              }).toList()
            else
              _KPeerCallForm(onSubmit: handleJoinWithCode),
          ],
        ],
      ),
    );

    final errorView = Container(
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
                    "${errorMsg}",
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

    if (this.inCall) {
      voipView = callView;
    } else if (KStringHelper.isExist(errorMsg)) {
      voipView = errorView;
    } else if (!isCalled) {
      voipView = initView;
    } else {
      voipView = connectView;
    }

    final body = voipView;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: KeyboardKiller(
        child: Scaffold(
          appBar: inCall || isCalled ? null : AppBar(),
          body: body,
        ),
      ),
    );
  }

  Widget _renderState() {
    Color bgColor = inCall ? Colors.green : Colors.grey;
    Color txtColor = Colors.white;
    String txt = inCall ? "Connected" : "Standby";
    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Text(
        txt,
        style:
            Theme.of(context).textTheme.titleLarge?.copyWith(color: txtColor),
      ),
    );
  }
}

class _KPeerCallVideoRender extends StatelessWidget {
  final RTCVideoRenderer videoRenderer;
  final double containerWidth;
  final double containerHeight;
  final int peerCount;
  final bool isAudioEnable;
  final bool isVideoEnable;
  final String displayName;
  final bool isLocal;

  _KPeerCallVideoRender({
    Key? key,
    required this.videoRenderer,
    required this.containerWidth,
    required this.containerHeight,
    required this.peerCount,
    required this.isAudioEnable,
    required this.isVideoEnable,
    required this.displayName,
    required this.isLocal,
  }) : super(key: key);

  double get calculatedHeight {
    double height = containerHeight;

    if (peerCount >= 2) {
      height = containerHeight / 2;
    }

    if (peerCount > 4) {
      height = containerHeight / 3;
    }

    return height;
  }

  double get calculatedWidth {
    double width = containerWidth;

    if (peerCount > 2) {
      width = containerWidth / 2;
    }

    return width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: calculatedWidth,
      height: calculatedHeight,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: isVideoEnable
                          ? RTCVideoView(
                              videoRenderer,
                              key: Key('${videoRenderer.srcObject!.id}'),
                              mirror: isLocal,
                              objectFit: RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitCover,
                            )
                          : Container(
                              color: Colors.black,
                              child: Center(
                                child: KUserAvatar(
                                  initial: displayName
                                      .split(' ')
                                      .map((e) => "${e}".capitalizeFirst)
                                      .join(''),
                                  size: calculatedWidth / 3,
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            ),
                    ),
                  ),
                  if (!isAudioEnable)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.mic_off_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (KStringHelper.isExist(displayName))
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          displayName,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 4.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KPeerCallForm extends StatefulWidget {
  final Future<dynamic> Function(String conferenceCode, String conferencePass)
      onSubmit;

  _KPeerCallForm({required this.onSubmit});

  @override
  State<StatefulWidget> createState() => _KPeerCallFormState();
}

class _KPeerCallFormState extends State<_KPeerCallForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController conferenceCodeController =
      TextEditingController();
  final TextEditingController conferencePassController =
      TextEditingController();
  final FocusNode conferencePassFocusNode = FocusNode();
  final FocusNode conferenceCodeFocusNode = FocusNode();

  bool isLoading = false;
  bool isConferencePassTouched = false;
  bool isConferenceCodeTouched = false;

  bool get isFormValid =>
      isConferencePassTouched &&
      isConferenceCodeTouched &&
      formKey.currentState != null &&
      formKey.currentState!.validate();

  double labelWidth = 50;

  @override
  void initState() {
    super.initState();

    conferencePassFocusNode.addListener(() {
      if (formKey.currentState != null) formKey.currentState!.validate();
      if (!isConferencePassTouched && !conferencePassFocusNode.hasFocus) {
        setState(() {
          isConferencePassTouched = true;
        });
      }
    });
    conferenceCodeFocusNode.addListener(() {
      if (formKey.currentState != null) formKey.currentState!.validate();
      if (!isConferenceCodeTouched && !conferenceCodeFocusNode.hasFocus) {
        setState(() {
          isConferenceCodeTouched = true;
        });
      }
    });
  }

  @override
  void dispose() {
    conferencePassFocusNode.dispose();
    conferenceCodeFocusNode.dispose();
    super.dispose();
  }

  void handleSubmit() async {
    this.setState(() {
      this.isLoading = true;
    });
    try {
      if (isFormValid) {
        widget.onSubmit(
            conferenceCodeController.text, conferencePassController.text);
      }
    } catch (ex) {
      print(ex);
    }
    if (mounted) {
      this.setState(() {
        this.isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkInButton = ElevatedButton(
      onPressed: isLoading || !isFormValid ? null : handleSubmit,
      style: KStyles.roundedButton(Theme.of(context).colorScheme.primary),
      child: Text(
        "Join",
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );

    final form = Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if ((value == null || value.isEmpty) &&
                    isConferenceCodeTouched) {
                  return 'Field required!';
                }
                return null;
              },
              style: Theme.of(context).textTheme.subtitle1,
              controller: conferenceCodeController,
              focusNode: conferenceCodeFocusNode,
              decoration: InputDecoration(
                hintText: 'Meeting Code',
                hintStyle: Theme.of(context).textTheme.subtitle1,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              validator: (value) {
                if ((value == null || value.isEmpty) &&
                    isConferencePassTouched) {
                  return 'Field required!';
                }
                return null;
              },
              style: Theme.of(context).textTheme.subtitle1,
              controller: conferencePassController,
              focusNode: conferencePassFocusNode,
              decoration: InputDecoration(
                hintText: 'Meeting Pass',
                hintStyle: Theme.of(context).textTheme.subtitle1,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            checkInButton,
          ]),
    );

    final body = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: form,
          ),
        ],
      ),
    );

    return body;
  }
}
