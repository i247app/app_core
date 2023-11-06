import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:app_core/app_core.dart';
import 'package:app_core/header/kaction.dart';
import 'package:app_core/helper/kpeer_webrtc_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:app_core/model/kremote_peer.dart';
import 'package:app_core/model/kwebrtc_conference.dart';
import 'package:app_core/model/kwebrtc_member.dart';
import 'package:app_core/ui/peer/widget/kpeer_button_view.dart';
import 'package:app_core/ui/peer/widget/kpeer_video_render.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/utils.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:queue/queue.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class KPeerCall extends StatefulWidget {
  final String? refApp;
  final String? refID;

  const KPeerCall({
    Key? key,
    this.refApp,
    this.refID,
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
  StreamSubscription? remotePeerLeaveStreamSubscription;

  final _localRenderer = RTCVideoRenderer();
  List<Map<String, dynamic>> _remoteRenderers = [];

  bool isFetchingMeeting = false;
  bool isCallSetting = false;
  bool isNeedInputPassForSlugCall = false;
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

  bool isSpeakerEnabled = true;
  bool isMySoundEnabled = true;
  bool isMySpeakerEnabled = true;
  bool isMyCameraEnabled = true;
  bool isBringMyCamBack = false;
  bool isPanelOpen = false;

  bool? get isMeetingAdmin => currentMeetingMember != null
      ? currentMeetingMember!.role == KWebRTCMember.MEMBER_ROLE_ADMIN
      : null;

  bool get isOnConnection =>
      _remoteRenderers
              .where((e) => e['remoteRenderer']?.srcObject != null)
              .length ==
          0 &&
      KPeerWebRTCHelper.remotePeers
              .where((e) => e.peerID != currentMeetingMember?.memberKey)
              .length >
          0;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    fetchMeeting();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    KPeerWebRTCHelper.dispose();
    connectionStatusStreamSubscription?.cancel();
    dataStreamSubscription?.cancel();
    localPlayerStreamSubscription?.cancel();
    remotePlayerStreamSubscription?.cancel();
    remotePeerLeaveStreamSubscription?.cancel();
    queue.dispose();
    super.dispose();
  }

  void fetchMeeting() async {
    if (isFetchingMeeting) return;

    setState(() {
      isFetchingMeeting = true;
    });

    try {
      final response = await KServerHandler.webRTCConferenceAction(
        kWebRTCConference: KWebRTCConference()
          ..kaction = KAction.LIST
          ..refApp = widget.refApp
          ..refID = widget.refID,
      );
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
      if (status == KPeerWebRTCStatus.CONNECTION) {
        if (isCallSetting) {
          setState(() {
            isCallSetting = false;
            isCalled = true;
          });
        } else if (inCall) {
          setState(() {
            inCall = false;
          });
        }
      } else if (status == KPeerWebRTCStatus.CONNECTED) {
        setState(() {
          inCall = true;
        });
      }
    }
  }

  void handleRemotePeerLeaveUpdate(KRemotePeer remotePeer) {
    if (mounted) {
      try {
        final index = _remoteRenderers
            .indexWhere((e) => e['peerID'] == remotePeer.peerID);
        if (index > -1) {
          setState(() {
            _remoteRenderers = _remoteRenderers
                .where((e) => e['peerID'] != remotePeer.peerID)
                .toList();
          });
        }
      } catch (ex) {}
    }
  }

  void handleLocalPlayerUpdate(mediaStream) async {
    if (mounted) {
      print('handleLocalPlayerUpdate');
      await _localRenderer.initialize();
      setState(() {
        _localRenderer.srcObject = mediaStream;
      });
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
            'isAudioEnable': true,
            'isVideoEnable': true,
            'displayName': '',
          }
        };
        if (remotePeer['stream'] != null) {
          final _remoteRenderer = RTCVideoRenderer();
          await _remoteRenderer.initialize();
          _remoteRenderer.srcObject = remotePeer['stream'];
          _remotePeer['remoteRenderer'] = _remoteRenderer;
        }

        this.setState(() {
          _remoteRenderers.add(_remotePeer);
        });
      } else {
        final _remotePeer = {
          ...remotePeer,
          'remoteRenderer': null,
          'metadata': {
            'isAudioEnable': true,
            'isVideoEnable': true,
            'displayName': '',
          }
        };
        if (remotePeer['stream'] != null) {
          final _remoteRenderer = RTCVideoRenderer();
          await _remoteRenderer.initialize();
          _remoteRenderer.srcObject = remotePeer['stream'];

          if (_remoteRenderer.srcObject?.id != null &&
              _remoteRenderer.srcObject?.id !=
                  _remotePeer['remoteRenderer']?.id) {
            _remotePeer['remoteRenderer'] = _remoteRenderer;
          }
        }

        this.setState(() {
          _remoteRenderers[index] = _remotePeer;
        });
      }

      sendMetadata([remotePeer['peer']]);
      sendDataPacket(
          [remotePeer['peer']],
          KPeerWebRTCHelper.PACKET_TYPE_RETRIEVE_METADATA,
          {
            'peerID': KPeerWebRTCHelper.localPeerId,
          });
      // calculateMaxVideoEachRow();
    }
  }

  void sendMetadata(List<KRemotePeer> peers) {
    print('sendMetadata');
    sendDataPacket(peers, KPeerWebRTCHelper.PACKET_TYPE_METADATA, {
      'peerID': KPeerWebRTCHelper.localPeerId,
      'metadata': {
        'isAudioEnable': isMySoundEnabled,
        'isVideoEnable': isMyCameraEnabled,
        'displayName': KPeerWebRTCHelper.localDisplayName,
      },
    });
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

  void handleDataUpdate(Map<String, dynamic> data) async {
    if (mounted) {
      final remotePeer = data['remotePeer'];
      final remotePeerData = data['data'];
      print('data ${remotePeer} ${remotePeerData['payload']}');

      switch (remotePeerData['type']) {
        case KPeerWebRTCHelper.PACKET_TYPE_METADATA:
          {
            final index = _remoteRenderers.indexWhere(
                (e) => e['peerID'] == remotePeerData['payload']['peerID']);
            if (index > -1 && remotePeerData['payload']['metadata'] != null) {
              this.setState(() {
                _remoteRenderers[index]['metadata'] =
                    remotePeerData['payload']['metadata'];
              });
            } else {
              // retry set metadata
              Future.delayed(
                  Duration(milliseconds: 250), () => handleDataUpdate(data));
            }
          }
          break;
        case KPeerWebRTCHelper.PACKET_TYPE_RETRIEVE_METADATA:
          {
            final index = _remoteRenderers.indexWhere(
                (e) => e['peerID'] == remotePeerData['payload']['peerID']);
            if (index > -1 &&
                _remoteRenderers[index]['peer']?.dataConnection != null) {
              sendMetadata([_remoteRenderers[index]['peer']]);
            } else {
              // retry set metadata
              Future.delayed(
                  Duration(milliseconds: 250), () => handleDataUpdate(data));
            }
          }
          break;
        case KPeerWebRTCHelper.CONTROL_SIGNAL_LEAVE:
          if (remotePeerData['payload']['peerID'] &&
              remotePeerData['payload']['peerID'] !=
                  currentMeetingMember?.memberKey) {
            KPeerWebRTCHelper.removePeer(remotePeerData['payload']['peerID']);
            final index = _remoteRenderers.indexWhere(
                (e) => e['peerID'] == remotePeerData['payload']['peerID']);
            if (index > -1) {
              this.setState(() {
                _remoteRenderers = _remoteRenderers
                    .where((_remoteRenderer) =>
                        _remoteRenderer['peerID'] !=
                        remotePeerData['payload']['peerID'])
                    .toList();
              });
            }
            print("[LEAVE] data packet received ${remotePeerData['payload']}");
          }
          break;
        case KPeerWebRTCHelper.CONTROL_SIGNAL_END:
          if (remotePeerData['payload']['peerID'] &&
              remotePeerData['payload']['peerID'] !=
                  currentMeetingMember?.memberKey) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => new AlertDialog(
                title: new Text('Call ended!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => safePop(true),
                    child: new Text('Ok'),
                  ),
                ],
              ),
            );
          }
          print("[END] data packet received ${remotePeerData['payload']}");
          break;
        default:
          print('Unrecognized data packet of type ${remotePeerData['type']}');
          break;
      }
    }
  }

  Future handleJoinWithCode({
    String? conferenceCode,
    String? conferenceSlug,
    required String conferencePass,
  }) async {
    try {
      await setupCall(
        KWebRTCConference()
          ..conferenceCode = conferenceCode
          ..conferenceSlug = conferenceSlug
          ..conferencePass = conferencePass,
      );
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
            KPeerWebRTCHelper.dataStream.listen(handleDataUpdate);
        localPlayerStreamSubscription =
            KPeerWebRTCHelper.localPlayerStream.listen(handleLocalPlayerUpdate);
        remotePeerLeaveStreamSubscription =
            KPeerWebRTCHelper.remotePeerLeaveStream.listen(handleRemotePeerLeaveUpdate);
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
          isNeedInputPassForSlugCall = false;
          isCalled = true;
        });
      } else {
        setState(() {
          isCallSetting = false;
          if (KStringHelper.isExist(meeting.conferenceSlug) &&
              !KStringHelper.isExist(meeting.conferencePass) &&
              !isNeedInputPassForSlugCall) {
            isNeedInputPassForSlugCall = true;
            currentMeeting = meeting;
          }
          ;
        });
      }
    } catch (ex) {
      print("ex ${ex}");
      setState(() {
        isCallSetting = false;
      });
    }
  }

  void safePop([final result]) {
    Navigator.of(context).pop(result);
  }

  void hangUp() async {
    try {
      final hangUpConfirm = await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text(KPhrases.webRTCCallLeave),
          actions: <Widget>[
            Row(
              children: [
                if (isMeetingAdmin ?? false) ...[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      KPhrases.webRTCCallEnd,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: KStyles.colorBGNo,
                          ),
                    ),
                  ),
                  Spacer(),
                ] else
                  Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: new Text(KPhrases.webRTCCallNo),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text(KPhrases.webRTCCallYes),
                ),
              ],
            ),
          ],
        ),
      );

      if (hangUpConfirm == null) {
        return;
      } else if (!hangUpConfirm) {
        if (currentMeeting != null && currentMeetingMember != null) {
          final response = await KServerHandler.webRTCConferenceAction(
            kWebRTCConference: currentMeeting!
              ..kaction = KAction.END
              ..webRTCMembers = [currentMeetingMember!],
          );

          if (response.isSuccess) {
            this.sendDataPacket(KPeerWebRTCHelper.remotePeers,
                KPeerWebRTCHelper.CONTROL_SIGNAL_END, {
              'peerID': KPeerWebRTCHelper.localPeerId,
            });
          }
        }
      } else {
        if (currentMeeting != null && currentMeetingMember != null) {
          final response = await KServerHandler.webRTCConferenceAction(
            kWebRTCConference: currentMeeting!
              ..kaction = KAction.STOP
              ..webRTCMembers = [currentMeetingMember!],
          );
        }
      }

      this.sendDataPacket(KPeerWebRTCHelper.remotePeers,
          KPeerWebRTCHelper.CONTROL_SIGNAL_LEAVE, {
        'peerID': KPeerWebRTCHelper.localPeerId,
      });
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
    sendMetadata(KPeerWebRTCHelper.remotePeers);
  }

  void onSpeakerToggled(value) {
    setState(() {
      isSpeakerEnabled = value;
    });

    final audioTrack = _localRenderer.srcObject?.getAudioTracks().first;
    if (audioTrack == null) return;

    audioTrack.enableSpeakerphone(value);
  }

  void onCameraToggled(value) {
    setState(() {
      isMyCameraEnabled = value;
    });

    final videoTrack = _localRenderer.srcObject?.getVideoTracks().first;
    if (videoTrack == null) return;

    videoTrack.enabled = value;
    sendMetadata(KPeerWebRTCHelper.remotePeers);
  }

  void copyTextToClipboard(String text) {
    Clipboard.setData(
      ClipboardData(text: text),
    );
    KSnackBarHelper.success(KPhrases.copied);
  }

  void showMeetingInfo() async {
    try {
      await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text(KPhrases.webRTCMeeting),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                      "${KPhrases.webRTCCode}: ${currentMeeting?.conferenceCode}"),
                  Spacer(),
                  IconButton(
                    onPressed:
                        !KStringHelper.isExist(currentMeeting?.conferenceCode)
                            ? null
                            : () => copyTextToClipboard(
                                currentMeeting!.conferenceCode!),
                    icon: Icon(Icons.copy_outlined),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Text(
                      "${KPhrases.webRTCPass}: ${currentMeeting?.conferencePass}"),
                  Spacer(),
                  IconButton(
                    onPressed:
                        !KStringHelper.isExist(currentMeeting?.conferencePass)
                            ? null
                            : () => copyTextToClipboard(
                                currentMeeting!.conferencePass!),
                    icon: Icon(Icons.copy_outlined),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: new Text(KPhrases.ok),
            ),
          ],
        ),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    final connectionBox = Container(
      width: deviceWidth,
      height: deviceHeight / 2,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              KPhrases.webRTCConnecting,
              textAlign: TextAlign.center,
              style: KStyles.normalText.copyWith(color: KStyles.lightGrey),
            ),
          ],
        ),
      ),
    );

    final callView = SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  if (_localRenderer.srcObject != null) ...[
                    KPeerVideoRender(
                      videoRenderer: _localRenderer,
                      containerHeight: deviceHeight,
                      containerWidth: deviceWidth,
                      peerCount: peerCount,
                      isAudioEnable: isMySoundEnabled,
                      isVideoEnable: isMyCameraEnabled,
                      displayName: KSessionData.me?.fullName ?? '',
                      isLocal: true,
                      isOnConnection: isOnConnection,
                    ),
                  ],
                  if (isOnConnection)
                    connectionBox
                  else
                    ...List.generate(_remoteRenderers.length, (index) {
                      final metadata = _remoteRenderers[index]['metadata'];
                      final _remoteRenderer =
                          _remoteRenderers[index]['remoteRenderer'];
                      return KPeerVideoRender(
                        videoRenderer: _remoteRenderer,
                        containerHeight: deviceHeight,
                        containerWidth: deviceWidth,
                        peerCount: peerCount,
                        isAudioEnable: metadata['isAudioEnable'],
                        isVideoEnable: metadata['isVideoEnable'],
                        displayName: metadata['displayName'] ?? '',
                        isLocal: false,
                      );
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
                isSpeakerEnabled: isSpeakerEnabled,
                isMicEnabled: this.isMySoundEnabled,
                isCameraEnabled: this.isMyCameraEnabled,
                type: KWebRTCCallType.video,
                onMicToggled: onMicToggled,
                onCameraToggled: onCameraToggled,
                onSpeakerToggled: onSpeakerToggled,
                onHangUp: hangUp,
                onShowMeetingInfo: (isMeetingAdmin ?? false) &&
                        KStringHelper.isExist(currentMeeting?.conferenceCode) &&
                        KStringHelper.isExist(currentMeeting?.conferencePass)
                    ? showMeetingInfo
                    : null,
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
            if (meetingList.length > 0 && !isNeedInputPassForSlugCall)
              ...List.generate(meetingList.length, (index) {
                final meeting = meetingList[index];

                if (KStringHelper.isExist(meeting.meetingName)) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed:
                          isCallSetting ? null : () => setupCall(meeting),
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
                    ),
                  );
                }

                return Container();
              }).toList()
            else
              _KPeerCallForm(
                onSubmit: handleJoinWithCode,
                conferenceSlug: currentMeeting?.conferenceSlug,
              ),
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

    if (KStringHelper.isExist(errorMsg)) {
      voipView = errorView;
    } else if (!isCalled) {
      voipView = initView;
    } else {
      voipView = callView;
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

class _KPeerCallForm extends StatefulWidget {
  final Future<dynamic> Function({
    String? conferenceCode,
    String? conferenceSlug,
    required String conferencePass,
  }) onSubmit;
  final String? conferenceSlug;

  _KPeerCallForm({
    required this.onSubmit,
    this.conferenceSlug,
  });

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

  bool get isJoinWithSlug => KStringHelper.isExist(widget.conferenceSlug);

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
        if (isJoinWithSlug) {
          widget.onSubmit(
            conferenceSlug: widget.conferenceSlug,
            conferencePass: conferencePassController.text,
          );
        } else {
          widget.onSubmit(
            conferenceCode: conferenceCodeController.text,
            conferencePass: conferencePassController.text,
          );
        }
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
            if (!isJoinWithSlug) ...[
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
            ],
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
